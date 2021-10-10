import 'dart:convert';

import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa_encrypt;
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:pointycastle/api.dart' as pointycastle;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pointycastle/export.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;

dynamic getValueFromStore(String key) {
  abcd();

  var hiveConfig = getIt<HiveConfig>();
  return hiveConfig.storeBox == null ? "" : hiveConfig.storeBox!.get(key);
}

void setValueToStore(String key, dynamic value) {
  var hiveConfig = getIt<HiveConfig>();
  if (hiveConfig.storeBox != null) {
    hiveConfig.storeBox!.put(key, value);
  }
}

void abcd() {
  var encryptManager = EncrytionManager();
  encryptManager.keyGen();
}

Future<bool> checkUserLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return Future.value(true);
}

Future<Position> getUserLocation() async {
  try {
    await checkUserLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  } catch (err) {
    throw Future.error(err);
  }
}

class Upload {
  Upload();

  static Future<String?> uploadSingleImage(
    XFile image,
    Function(String?) callback,
  ) async {
    var hiveConfig = getIt<HiveConfig>();
    String token = hiveConfig.storeBox!.get(ACCESS_TOKEN_KEY);

    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse(UPLOAD_IMAGE_URL);

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      "Authorization": "Bearer $token"
    };
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(image.path),
    );
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode != 201) {}

    response.stream.transform(utf8.decoder).listen((event) {
      final resJSON = json.decode(event) as Map<String, dynamic>;
      callback(resJSON['filename']);
    });
  }
}

class EncrytionManager {
  // -----BEGIN RSA PRIVATE KEY-----
  // MIIBOgIBAAJBAJsKyNf7BlLHVRbyq3J2/GacBTPcrj4+Rv1aZfIM/meB9WcV9f6V
  // 2qEP2+ee5zK4VR7+rNLgMXC9eplHartVVj0CAwEAAQJBAJIGJUXugnUikoyrgDit
  // wmluFyRSe7XZ+AiUxKGmBVI8SDS3gkijnWt/RoFVNE/sdpE8PszqbUCgzhJ7lxhp
  // +4ECIQDJeK1ts87XExmN+BHvYvelfl8yxzzNExsiGXKUPhaEHQIhAMUBKxemx7w8
  // IndblHWxmQBczhO8bPK0jCRAxFqDqUChAiArFmQA0jOqS6trcWJkkAXmnuA9O98E
  // /NEQueCHU7/9AQIgV6bwbGKJRcgfsalugXsWTyH7kq5obwhDvjGO65Le8GECIC69
  // fFb9LaBizkaU7SN3ExSsrd+N3LaeaZ0wfA/tUscm
  // -----END RSA PRIVATE KEY-----

  RSAPublicKey? _clientPublicKey;
  String? _clientPublicKeyAsString;
  RSAPrivateKey? _clientPrivateKey;
  var helper = rsa_encrypt.RsaKeyHelper();

  Future<String> encrypt(String data) async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('rsa_pub_key.pem');

    var encryptedData = rsa_encrypt.encrypt(data, publicKey);
    return Future.value(encryptedData);
  }

  String decrypt(String data) {
    if (_clientPrivateKey == null) {
      throw ErrorDescription("Client private key is null");
    }

    var decryptedData = rsa_encrypt.decrypt(data, _clientPrivateKey!);

    return decryptedData;
  }

  void keyGen() async {
    final keyPair = await getKeyPair();
    _clientPublicKey = keyPair.publicKey as RSAPublicKey;
    _clientPrivateKey = keyPair.privateKey as RSAPrivateKey;

    var pubKey = helper.encodePublicKeyToPemPKCS1(_clientPublicKey!);
    _clientPublicKeyAsString = helper.removePemHeaderAndFooter(pubKey);

    var priKey = helper.encodePrivateKeyToPemPKCS1(_clientPrivateKey!);
    print("$_clientPublicKeyAsString $priKey");
  }

  Future<
      pointycastle.AsymmetricKeyPair<pointycastle.PublicKey,
          pointycastle.PrivateKey>> getKeyPair() {
    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }
}

Route routeSlideFromBottomToTop(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

String? transformString(String key, String? data) {
  if (data == null) return "";
  return "$key: ${"\"$data\""},";
}

String transformVisibility(JouneyVisibility? jouneyVisibility) {
  if (jouneyVisibility == null) return "";
  return "visibility: ${jouneyVisibility == JouneyVisibility.private ? "PRIVATE" : "PUBLIC"},";
}

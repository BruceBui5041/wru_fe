import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:pointycastle/api.dart' as pointycastle;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pointycastle/export.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;

dynamic getValueFromStore(String key) {
  var hiveConfig = getIt<HiveConfig>();
  return hiveConfig.storeBox == null ? "" : hiveConfig.storeBox!.get(key);
}

void setValueToStore(String key, dynamic value) {
  var hiveConfig = getIt<HiveConfig>();
  if (hiveConfig.storeBox != null) {
    hiveConfig.storeBox!.put(key, value);
  }
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

  // Future<String> encrypt(String data) async {
  //   final encrypter = Encrypter(RSA(publicKey: publicKey));

  //   var encryptedData = encrypter.encrypt(data);

  //   RSAPublicKey(BigInt.from(512), BigInt.from(512));

  //   return Future.value(encryptedData.base64);
  // }

  Future<String> decrypt(String data) async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('rsa_pub_key.pem');
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    var encryptedData = encrypter.encrypt(data);

    return Future.value(encryptedData.base64);
  }

  void keyGen() {
    final pair = _generateRSAkeyPair(_exampleSecureRandom());
    final public = pair.publicKey;
    final private = pair.privateKey;

    print("${public}");
  }

  pointycastle.AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>
      _generateRSAkeyPair(
    pointycastle.SecureRandom secureRandom, {
    int bitLength = 2048,
  }) {
    // Create an RSA key generator and initialize it
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(
          BigInt.parse('65537'),
          bitLength,
          64,
        ),
        secureRandom,
      ));

    // Use the generator
    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  pointycastle.SecureRandom _exampleSecureRandom() {
    final secureRandom = pointycastle.SecureRandom('Fortuna')
      ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)),
      );
    return secureRandom;
  }
}

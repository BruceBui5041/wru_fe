import 'package:geolocator/geolocator.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';

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

class SetAction {
  final dynamic object;
  final String id;
  SetAction(this.object, this.id);

  call() => object;

  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (other is! SetAction) {
      return false;
    }
    return id == (other).id;
  }

  @override
  String toString() => id;
}

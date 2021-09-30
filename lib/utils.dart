import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';

String getValueFromStore(String key) {
  var hiveConfig = getIt<HiveConfig>();
  return hiveConfig.storeBox == null ? "" : hiveConfig.storeBox!.get(key);
}

void setValueToStore(String key, String value) {
  var hiveConfig = getIt<HiveConfig>();
  if (hiveConfig.storeBox != null) {
    hiveConfig.storeBox!.put(key, value);
  }
}

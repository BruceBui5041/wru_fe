import 'package:shared_preferences/shared_preferences.dart';

Future<String> getValueFromSharePreference(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> setValueToSharePreference(String key, String value) async {
  assert(value.isEmpty == false);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

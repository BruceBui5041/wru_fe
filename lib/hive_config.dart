import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wru_fe/constanst.dart';

class HiveConfig {
  HiveConfig();
  Box? storeBox;

  Future<void> initHive() async {
    Directory dir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    storeBox = await Hive.openBox(storeName);
  }
}

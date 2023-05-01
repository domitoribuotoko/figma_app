import 'package:figma_app/base/app_classes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  late Box<AppDaylyData> box;
  late Box<AppDaylyData> fakeDataBox;
  late ValueNotifier<String> daylyData;
  var f = NumberFormat("###.##");
  late SharedPreferences sharedPreferences;
  late ValueNotifier<bool> fatSettings;
  late ValueNotifier<bool> isShowFakeData;
}

final config = AppConfig();

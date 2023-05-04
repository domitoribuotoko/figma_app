import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:figma_app/base/app_classes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  late Box<AppDaylyData> box;
  late Box<AppDaylyData> fakeDataBox;
  late ValueNotifier<String> daylyData;
  var f = locale.NumberFormat("###.##");
  late SharedPreferences sharedPreferences;
  late ValueNotifier<bool> fatSettings;
  late ValueNotifier<bool> isShowFakeData;
  Map<String, String> availableTranslations = {
    'en': 'English',
    'ru': 'Русский',
    'uk': 'Українська',
  };
}

final config = AppConfig();

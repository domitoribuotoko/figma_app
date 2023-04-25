import 'package:figma_app/base/app_classes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AppConfig {
  late Box<AppDaylyData> box;
  late ValueNotifier<String> daylyData;
  var f = NumberFormat("###.##");
}

final config = AppConfig();

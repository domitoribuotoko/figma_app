import 'package:figma_app/base/app_classes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppConfig {
  late ValueNotifier<Box<AppDaylyData>> box ;
}

final config = AppConfig();

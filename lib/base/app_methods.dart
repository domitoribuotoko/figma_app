import 'dart:typed_data';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_classes.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:intl/intl.dart' as intl;

class AppMethods {
  double ratio() {
    late double size;
    size = metrix.screenHeight / 844;
    return size;
  }

  double vSizeCalc(double figmaSize) {
    late double size;
    double figmaScreenHeight = 844;
    size = metrix.screenHeight * (figmaSize / figmaScreenHeight);
    return size;
  }

  double hSizeCalc(double figmaSize) {
    late double size;
    double figmaScreenWidth = 390;
    size = metrix.screenWidth * (figmaSize / figmaScreenWidth);
    return size;
  }

  String dateToKey() {
    return intl.DateFormat('dd.MM.y').format(
      DateTime.now(),
    );
  }

  getPackageInfo() async {
    // AppConfig.packageInfo = await PackageInfo.fromPlatform();
  }

  getHiveList() async {
    Hive
      ..init(await getApplicationDocumentsDirectory().then((value) => value.path))
      ..registerAdapter(FatAdapter())
      ..registerAdapter(AppDaylyDataAdapter());
    config.box = ValueNotifier<Box<AppDaylyData>>(await Hive.openBox(
      'mainBox',
    ));
    // await config.box.value.deleteFromDisk();
    if (!config.box.value.containsKey(dateToKey())) {
      await config.box.value.put(dateToKey(), AppDaylyData(date: DateTime.now()));
    }
  }

  double getLog10(double x) {
    late double result;
    result = math.log(x) / math.ln10;
    return result;
  }

  String fatCategory(String sex, double fatPercent) {
    if (sex == 'male') {
      if (fatPercent < 2) {
        return 'Critical Low';
      }
      if (fatPercent >= 2 && fatPercent <= 5) {
        return 'Low';
      }
      if (fatPercent > 5 && fatPercent <= 14) {
        return 'Athletes';
      }
      if (fatPercent > 14 && fatPercent <= 18) {
        return 'Normal';
      }
      if (fatPercent > 18 && fatPercent <= 25) {
        return 'Acceptable';
      } else {
        return 'Excess';
      }
    } else {
      if (fatPercent < 10) {
        return 'Critical Low';
      }
      if (fatPercent >= 10 && fatPercent <= 13) {
        return 'Low';
      }
      if (fatPercent > 13 && fatPercent <= 20) {
        return 'Athletes';
      }
      if (fatPercent > 20 && fatPercent <= 25) {
        return 'Normal';
      }
      if (fatPercent > 25 && fatPercent <= 32) {
        return 'Acceptable';
      } else {
        return 'Excess';
      }
    }
  }

  List<dynamic> calculateFats(
    String sex,
    double height,
    double weight,
    double neckGirth,
    double waistCircum,
    double? hipGirth,
  ) {
    List<dynamic> values = [];
    late double fatPercent;
    late double fatMass;
    late double massWithoutFat;
    late String category;
    if (sex == 'male') {
      fatPercent = 495 / (1.0324 - 0.19077 * (getLog10(waistCircum - neckGirth)) + 0.15456 * (getLog10(height))) - 450;
    } else {
      fatPercent =
          (495 / (1.29579 - 0.35004 * (getLog10(waistCircum + hipGirth! - neckGirth)) + 0.22100 * (getLog10(height)))) -
              450;
    }

    fatMass = weight * (fatPercent / 100);
    massWithoutFat = weight - fatMass;
    category = fatCategory(sex, fatPercent);
    values.addAll([fatPercent, fatMass, massWithoutFat, category]);
    return values;
  }

  Shader setSweepGradienForCircularChart(ChartShaderDetails chartShaderDetails, Value data, double maximum) {
    int dataRatio() {
      double degree = 360 * (data.calories / maximum);
      return degree.toInt() == 0 ? 1 : degree.toInt();
    }

    double degreeToRadian(int deg) => deg * (math.pi / 180);
    Float64List resolveTransform(Rect bounds, TextDirection textDirection) {
      final GradientTransform transform = GradientRotation(degreeToRadian(-90));
      return transform.transform(bounds, textDirection: textDirection)!.storage;
    }

    return ui.Gradient.sweep(
      chartShaderDetails.outerRect.center,
      [
        colors.circularGradientStart,
        colors.circularGradientEnd,
      ],
      [0, 1],
      TileMode.clamp,
      degreeToRadian(0),
      degreeToRadian(dataRatio()),
      resolveTransform(
        chartShaderDetails.outerRect,
        TextDirection.ltr,
      ),
    );
  }
}

final method = AppMethods();

import 'dart:typed_data';
import 'package:figma_app/base/app_constans.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_classes.dart';
import 'app_config.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

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

  getPackageInfo() async {
    AppConfig.packageInfo = await PackageInfo.fromPlatform();
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

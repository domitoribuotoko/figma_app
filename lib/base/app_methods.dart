import 'dart:typed_data';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_classes.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;

class AppMethods {
  initSp() async {
    config.sharedPreferences = await SharedPreferences.getInstance();

    var value = config.sharedPreferences.getBool('fatSettings');
    if (value == null) {
      await config.sharedPreferences.setBool('fatSettings', true);
    }
    config.fatSettings = ValueNotifier<bool>(config.sharedPreferences.getBool('fatSettings')!);
    value = null;

    value = config.sharedPreferences.getBool('showFakeData');
    if (value == null) {
      await config.sharedPreferences.setBool('showFakeData', false);
    }
    config.isShowFakeData = ValueNotifier<bool>(config.sharedPreferences.getBool('showFakeData')!);
  }

  fatSettingsSet(bool value) async {
    await config.sharedPreferences.setBool('fatSettings', value);
  }

  fakeDataSet(bool value) async {
    await config.sharedPreferences.setBool('showFakeData', value);
  }

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

  String dateFormat(DateTime time) {
    return intl.DateFormat('dd.MM.y').format(
      time,
    );
  }

  getPackageInfo() async {
    // AppConfig.packageInfo = await PackageInfo.fromPlatform();
  }

  String getLinkFromId(String id) {
    String youtubeUrl = 'https://www.youtube.com/watch?v=$id';
    return youtubeUrl;
  }

  String getLinkToVideoPreviewMaxRes(String id) {
    String link = 'https://i.ytimg.com/vi/$id/maxresdefault.jpg';
    return link;
  }

  String getLinkToVideoPreviewHQRes(String id) {
    String link = 'https://i.ytimg.com/vi/$id/hqdefault.jpg';
    return link;
  }

  Future<bool> validateImage(String link) async {
    bool checkIfImage(String param) {
      if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
        return true;
      }
      return false;
    }

    http.Response res;
    try {
      res = await http.get(Uri.parse(link));
    } catch (e) {
      return false;
    }

    if (res.statusCode != 200) return false;
    Map<String, dynamic> data = res.headers;
    return checkIfImage(data['content-type']);
  }

  Future<Image> getVideoPreview(String id) async {
    if (await validateImage(getLinkToVideoPreviewMaxRes(id)) == true) {
      return Image.network(
        getLinkToVideoPreviewMaxRes(id),
      );
    } else {
      return Image.network(
        getLinkToVideoPreviewHQRes(id),
      );
    }
  }

  List<FatData> getChartFatData() {
    List<FatData> data = [];
    if (config.isShowFakeData.value == false) {
      for (var i = 0; i < config.box.values.length; i++) {
        var element = config.box.values.elementAt(i);
        if (element.fat != null) {
          data.add(
            FatData(
              element.fat!.bodyFatPercentage,
              element.date,
            ),
          );
        }
      }
    } else {
      for (var i = 0; i < config.fakeDataBox.values.length; i++) {
        var element = config.fakeDataBox.values.elementAt(i);
        if (element.fat != null) {
          data.add(
            FatData(
              element.fat!.bodyFatPercentage,
              element.date,
            ),
          );
        }
      }
    }

    return data;
  }

  getHiveList() async {
    Hive
      ..init(await getApplicationDocumentsDirectory().then((value) => value.path))
      ..registerAdapter(FatAdapter())
      ..registerAdapter(AppDaylyDataAdapter());
    config.box = await Hive.openBox('mainBox');
    config.fakeDataBox = await Hive.openBox('fakeDataBox');

    if (config.fakeDataBox.isEmpty) {
      await putFakeData();
    }
    if (method.dateFormat(config.fakeDataBox.getAt(13)!.date) != method.dateFormat(DateTime.now())) {
      await config.fakeDataBox.deleteFromDisk();
      config.fakeDataBox = await Hive.openBox('fakeDataBox');
      await putFakeData();
    }

    if (!config.box.containsKey(dateToKey())) {
      await config.box.put(dateToKey(), AppDaylyData(date: DateTime.now()));
    }
    config.daylyData = ValueNotifier<String>(config.box.get(method.dateToKey())!.date.toString());
  }

  putFakeData() async {
    for (var i = 0; i < 14; i++) {
      await config.fakeDataBox.add(
        AppDaylyData(
          date: DateTime.now().subtract(Duration(days: 13 - i)),
          fat: Fat(30 - (i.toDouble() + math.Random().nextDouble()), 5, 65, 'FakeData'),
        )
          ..food.addAll(
            List<Map<String, int>>.generate(
              math.Random().nextInt(3) + 1,
              (index) {
                return {'Product $index': math.Random().nextInt(300) + 100};
              },
            ),
          )
          ..expenditure.addAll(
            List<Map<String, int>>.generate(
              math.Random().nextInt(3) + 1,
              (index) {
                return {'Expenditure $index': math.Random().nextInt(300) + 100};
              },
            ),
          ),
      );
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

  Shader setSweepGradienForCircularChart(ChartShaderDetails chartShaderDetails, CaloriesValue data, double maximum) {
    int dataRatio() {
      double degree = 360 * (data.calories / maximum);
      if (degree.toString() == 'NaN') {
        degree = 0;
      }
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

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive/hive.dart';

part 'adapters.dart';

class CaloriesValue {
  String x;
  double calories;
  CaloriesValue(
    this.x,
    this.calories,
  );
}

class ModelSport {
  String name;
  String picUrl;
  String desc;
  ModelSport({
    required this.name,
    required this.picUrl,
    required this.desc,
  });
}

class ExerciseDetails {
  String name;
  String description;
  List<String> procedures;
  ExerciseDetails(
    this.name,
    this.procedures,
    this.description,
  );
}

class Article {
  String title;
  String urlLink;
  Article(
    this.title,
    this.urlLink,
  );
}

class Video {
  String title;
  String id;
  Video(
    this.title,
    this.id,
  );
}

class FatData {
  FatData(
    this.x,
    this.t,
  );
  double x;
  DateTime t;
}

@HiveType(typeId: 1)
class AppDaylyData extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  List<Map<String, int>> food = [];
  @HiveField(2)
  List<Map<String, int>> expenditure = [];
  @HiveField(3)
  Fat? fat;
  AppDaylyData({
    required this.date,
    this.fat,
  });
}

@HiveType(typeId: 2)
class Fat extends HiveObject {
  @HiveField(0)
  double bodyFatPercentage;
  @HiveField(1)
  double fatMass;
  @HiveField(2)
  double massWithoutFat;
  @HiveField(3)
  String category;
  Fat(
    this.bodyFatPercentage,
    this.fatMass,
    this.massWithoutFat,
    this.category,
  );
}

class MyInAppBrowser extends InAppBrowser {}

import 'package:hive/hive.dart';

part 'adapters.dart';

class Value {
  String x;
  double calories;
  Value(
    this.x,
    this.calories,
  );
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
class Fat extends HiveObject{
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

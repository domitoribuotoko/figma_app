class Value {
  String x;
  int calories;
  Value(
    this.x,
    this.calories,
  );
}

class Fat {
  double bodyFatPercentage;
  double fatMass;
  double massWithoutFat;
  String category;
  Fat(
    this.bodyFatPercentage,
    this.fatMass,
    this.massWithoutFat,
    this.category,
  );
}

class AppDaylyData {
  final DateTime date;
  List<Map<String, int>> food = [];
  List<Map<String, int>> expenditure = [];
  Fat? fat;
  AppDaylyData({
    required this.date,
    this.fat,
  });
}

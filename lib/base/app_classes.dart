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

class Product {
  int? id;
  String? title;
  String? description;
  num? price;
  num? discountPercentage;
  num? rating;
  num? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = json['rating'];
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['discountPercentage'] = discountPercentage;
    data['rating'] = rating;
    data['stock'] = stock;
    data['brand'] = brand;
    data['category'] = category;
    data['thumbnail'] = thumbnail;
    data['images'] = images;
    return data;
  }
}


class Query {
  List<Product>? products;
  int? total;
  int? skip;
  int? limit;

  Query({this.products, this.total, this.skip, this.limit});

  Query.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

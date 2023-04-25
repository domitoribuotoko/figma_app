import 'package:dio/dio.dart';
import 'package:figma_app/base/app_classes.dart';

class Repository {
  Future<List<Product>> get(String category) async {
    List<Product> query = [];
    Response r;
    if (category == 'all') {
      r = await Dio().get('https://dummyjson.com/products?limit=0');
    } else {
      r = await Dio().get('https://dummyjson.com/products/category/$category');
    }
    try {
      for (var element in r.data['products']) {
        query.add(Product.fromJson(element));
      }
      return query;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<String>> getCategories() async {
    List<String> q = [];
    Response r = await Dio().get('https://dummyjson.com/products/categories');
    try {
      for (var element in r.data) {
        q.add(element);
      }
      return q;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

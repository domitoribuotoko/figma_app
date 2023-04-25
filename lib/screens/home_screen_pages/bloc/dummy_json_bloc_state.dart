part of 'dummy_json_bloc_bloc.dart';

@immutable
abstract class DummyJsonBlocState {}

@immutable
abstract class CategoriesState {}

class LoadingProductState extends DummyJsonBlocState {}

class LoadingCategoriesState extends CategoriesState {}

class ProductLoadedState extends DummyJsonBlocState {
  final List<Product> productData;
  ProductLoadedState(this.productData);
}

class CategoriesLoaded extends CategoriesState {
  final List<String> categoriesList;
  CategoriesLoaded(this.categoriesList);
}

class LoadingErrorState extends DummyJsonBlocState {
  final String error;
  LoadingErrorState(this.error);
}

class LoadingCategoriesErrorState extends CategoriesState {
  final String error;
  LoadingCategoriesErrorState(this.error);
}

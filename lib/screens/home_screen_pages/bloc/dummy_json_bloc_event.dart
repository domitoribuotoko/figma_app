part of 'dummy_json_bloc_bloc.dart';

@immutable
abstract class DummyJsonBlocEvent {}

@immutable
abstract class CategoriesBlocEvent {}

class GetProducts extends DummyJsonBlocEvent {
  final String category;
  GetProducts(this.category);
}

class GetCategories extends CategoriesBlocEvent {
  GetCategories();
}

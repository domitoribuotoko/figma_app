import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/screens/home_screen_pages/bloc/repo.dart';

import 'package:meta/meta.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'dummy_json_bloc_event.dart';
part 'dummy_json_bloc_state.dart';

class DummyJsonBlocBloc extends Bloc<DummyJsonBlocEvent, DummyJsonBlocState> {
  final Repository repository;
  DummyJsonBlocBloc(this.repository) : super(LoadingProductState()) {
    on<GetProducts>(
      (event, emit) async {
        try {
          emit(LoadingProductState());
          final productList = await repository.get(event.category);
          emit(ProductLoadedState(productList));
        } catch (e) {
          emit(LoadingErrorState(e.toString()));
        }
      },
    );
  }
}

class CategoriesBloc extends Bloc<CategoriesBlocEvent, CategoriesState> {
  final Repository repository;
  CategoriesBloc(this.repository) : super(LoadingCategoriesState()) {
    on<GetCategories>(
      (event, emit) async {
        try {
          final categoryList = await repository.getCategories();
          emit(CategoriesLoaded(categoryList));
        } catch (e) {
          emit(LoadingCategoriesErrorState(e.toString()));
        }
      },
    );
  }
}

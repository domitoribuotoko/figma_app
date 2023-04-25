import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/app_constans.dart';
import 'bloc/dummy_json_bloc_bloc.dart';
import 'bloc/repo.dart';

ValueNotifier<String> currentCategory = ValueNotifier<String>('all');

class DummyJson extends StatefulWidget {
  const DummyJson({super.key});

  @override
  State<DummyJson> createState() => _DummyJsonState();
}

class _DummyJsonState extends State<DummyJson> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DummyJsonBlocBloc>(
          create: (context) {
            return DummyJsonBlocBloc(Repository())..add(GetProducts('all'));
          },
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) {
            return CategoriesBloc(Repository())..add(GetCategories());
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.mainBackgrounColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 92,
          title: Text(
            'DummyJson',
            style: tS.main32TS,
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                callback(String category) {
                  if (context.read<DummyJsonBlocBloc>().state is LoadingProductState) {
                    return;
                  } else {
                    context.read<DummyJsonBlocBloc>().add(GetProducts(category));
                  }
                }

                if (state is LoadingCategoriesState) {
                  return loadingWidget();
                }
                if (state is LoadingCategoriesErrorState) {
                  return errorWidget(state.error);
                }
                if (state is CategoriesLoaded) {
                  return categoryListWidget(state.categoriesList, callback);
                } else {
                  return Container();
                }
              },
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<DummyJsonBlocBloc, DummyJsonBlocState>(
                  builder: (context, state) {
                    if (state is LoadingProductState) {
                      return loadingWidget();
                    }
                    if (state is LoadingErrorState) {
                      return errorWidget(state.error);
                    }
                    if (state is ProductLoadedState) {
                      return productListWidget(state.productData);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget errorWidget(String error) {
    return Text(
      'Error $error',
    );
  }

  Widget productListWidget(List<Product> productData) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: method.hSizeCalc(20),
      ),
      child: ListView.separated(
        cacheExtent: 100,
        itemCount: productData.length,
        itemBuilder: (context, index) {
          return productContainer(productData[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black,
          );
        },
      ),
    );
  }

  Widget categoryListWidget(List<String> categories, Function(String category) callback) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        left: method.hSizeCalc(20),
        right: method.hSizeCalc(20),
      ),
      height: 41,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 1 + categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return categoryContainer('all', callback);
                }
                return categoryContainer(categories[index - 1], callback);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 5,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryContainer(String category, Function(String category) callback) {
    return GestureDetector(
      onTap: () {
        currentCategory.value = category;
        callback(category);
      },
      child: ValueListenableBuilder(
        valueListenable: currentCategory,
        builder: (context, value, _) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: currentCategory.value == category ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            height: 41,
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  color: currentCategory.value == category ? Colors.black : Colors.white,
                  // fontSize: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productContainer(Product product) {
    List<String> images = [...product.images!];

    ValueNotifier<String> currentImage = ValueNotifier<String>(images[0]);
    return SizedBox(
      width: metrix.screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '${product.title!} — ',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product.category!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '${product.price}\$',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: " — ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const WidgetSpan(
                      child: Icon(
                        Icons.star_rate,
                        size: 17,
                      ),
                    ),
                    TextSpan(
                      text: ' ${product.rating!}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            product.description!,
            maxLines: 100,
          ),
          ValueListenableBuilder(
            valueListenable: currentImage,
            builder: (context, value, child) {
              return SizedBox(
                // color: Colors.white,
                height: 300,
                width: metrix.screenWidth - method.hSizeCalc(40),
                child: Center(
                  child: Image.network(
                    currentImage.value,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    currentImage.value = images[index];
                  },
                  child: Image.network(
                    images[index],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:figma_app/screens/home_screen_pages/grapsh_pages/calculate_page.dart';
import 'package:figma_app/screens/home_screen_pages/grapsh_pages/calories_details.dart';
import 'package:figma_app/screens/home_screen_pages/grapsh_pages/fat_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

late TabController graphPageTabController;
ValueNotifier<int> tabGraphPageIndex = ValueNotifier<int>(0);
double _tabBarViewPortHeight = 0;
double _tabBarScrollHeight = 0;
final ValueNotifier<bool> _isScrollabe = ValueNotifier<bool>(true);

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    graphPageTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: tabGraphPageIndex.value,
    );
  }

  @override
  void dispose() {
    super.dispose();
    graphPageTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: ValueListenableBuilder(
              valueListenable: _isScrollabe,
              builder: (context, value, _) {
                return SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: DashboardHeaderPersistentDelegate(
                    isScrollable: _isScrollabe.value,
                  ),
                );
              },
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: method.hSizeCalc(20)),
        child: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                _tabBarViewPortHeight = context.size!.height;
              },
            );
            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: graphPageTabController,
              children: <Widget>[
                CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: Builder(
                        builder: (context) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) {
                              _tabBarScrollHeight = context.size!.height;
                              _isScrollabe.value = _tabBarScrollHeight > _tabBarViewPortHeight;
                            },
                          );
                          return Column(
                            children: List<Widget>.generate(
                              config.box.length,
                              (index) {
                                if (config.box.isEmpty) {
                                  return const Text('no data');
                                }
                                if (index == config.box.length - 1) {
                                  return ValueListenableBuilder(
                                    valueListenable: config.daylyData,
                                    builder: (context, value, child) {
                                      return _caloriesTabContainer(index);
                                    },
                                  );
                                }
                                return _caloriesTabContainer(index);
                              },
                            ).reversed.toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: ValueListenableBuilder(
                        valueListenable: config.fatSettings,
                        builder: (context, valeu, _) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (timeStamp) {
                              _tabBarScrollHeight = context.size!.height;
                              _isScrollabe.value = _tabBarScrollHeight > _tabBarViewPortHeight;
                            },
                          );
                          return Column(
                            children: List<Widget>.generate(
                              config.box.length,
                              (index) {
                                if (config.box.isEmpty) {
                                  return const Text('no data');
                                }
                                if (index == config.box.length - 1) {
                                  return ValueListenableBuilder(
                                    valueListenable: config.daylyData,
                                    builder: (context, value, child) {
                                      return _fatTabContainer(index);
                                    },
                                  );
                                }
                                return _fatTabContainer(index);
                              },
                            ).reversed.toList(),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _caloriesTabContainer(int index) {
    var item = config.box.getAt(index);
    var foodSumm = 0;
    var expendSumm = 0;
    for (Map<String, int> element in item!.food) {
      foodSumm = foodSumm + element.values.first;
    }
    for (Map<String, int> element in item.expenditure) {
      expendSumm = expendSumm + element.values.first;
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CaloriesDetails(
                data: item,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd.MM.y').format(item.date),
                  style: tS.grey16TS1,
                ),
                Text(
                  '${(foodSumm - expendSumm)} kcal',
                  style: tS.grey16TS1,
                ),
              ],
            ),
            Container(
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Food',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1,
                        ),
                      ),
                      Text(
                        '$foodSumm kcal',
                        style: tS.grey20TS1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expenditure',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1,
                        ),
                      ),
                      Text(
                        '-$expendSumm  kcal',
                        style: tS.grey20TS1,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _fatTabContainer(int index) {
    var item = config.box.getAt(index);
    late AppDaylyData? itemBefore;
    late double? fatBefore;
    double? difference;
    var fatPercent = item!.fat?.bodyFatPercentage;

    if (index > 0 && fatPercent != null) {
      for (var i = 1; i < index + 1; i++) {
        itemBefore = config.box.getAt(index - i);
        fatBefore = itemBefore!.fat?.bodyFatPercentage;
        if (fatBefore != null) {
          i = config.box.length;
        }
      }
      if (fatBefore != null) {
        difference = fatPercent - fatBefore;
      }
    }

    String getFatValue() {
      if (index == 0 || difference == null) {
        return config.f.format(fatPercent);
      } else {
        if (difference > 0) {
          return '+${config.f.format(difference)}';
        } else {
          return config.f.format(difference);
        }
      }
    }

    String getFatString() {
      if (index == 0 || difference == null) {
        return 'fat. %';
      } else {
        if (difference > 0) {
          return '+fat. %';
        } else {
          return '-fat. %';
        }
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const FatDetails();
            },
          ),
        );
      },
      child: ValueListenableBuilder(
          valueListenable: config.fatSettings,
          builder: (context, value, _) {
            return Visibility(
              visible: fatPercent != null ? true : config.fatSettings.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd.MM.y').format(item.date),
                          style: tS.grey16TS1,
                        ),
                      ],
                    ),
                    Container(
                      height: 51,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        // vertical: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          fatPercent != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getFatString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        // height: 1.05,
                                      ),
                                    ),
                                    Text(
                                      ' ${getFatValue()} %',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: colors.greyColor,
                                        // height: 1.05,
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    'Not recorded fat data this day',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: colors.greyColor,
                                      // height: 1.05,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class DashboardHeaderPersistentDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderPersistentDelegate({
    required this.isScrollable,
  });
  bool isScrollable = true;
  double currentSize = 200;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _tabBarViewPortHeight = metrix.screenHeight -
            context.findRenderObject()!.paintBounds.height -
            metrix.bottomNavBarHeight -
            metrix.statusBarHeight;
        _isScrollabe.value = _tabBarScrollHeight > _tabBarViewPortHeight;
      },
    );
    double shrinkPercentage =
        isScrollable ? min(1, shrinkOffset / (maxExtent - minExtent)) : min(1, shrinkOffset / (maxExtent - 200));
    currentSize = isScrollable
        ? maxExtent - shrinkOffset
        : (maxExtent - shrinkOffset) < currentSize
            ? currentSize
            : maxExtent - shrinkOffset;

    return Container(
      decoration: BoxDecoration(
        // color: Colors.red,
        gradient: LinearGradient(
          begin: Alignment.bottomCenter - const Alignment(0, 0.1),
          end: Alignment.bottomCenter,
          colors: [
            colors.mainBackgrounColor,
            colors.mainBackgrounColor.withOpacity(0),
          ],
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: method.hSizeCalc(20),
      ),
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: max(
                10,
                35 * (1 - shrinkPercentage),
              ),
            ),
            constraints: BoxConstraints.tightFor(
              height: max(
                50,
                method.hSizeCalc(165) * (1 - shrinkPercentage),
              ),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              children: [
                ValueListenableBuilder(
                  valueListenable: config.daylyData,
                  builder: (context, value, _) {
                    var item = config.box.get(method.dateToKey());
                    double foodSumm = 0;
                    double expendSumm = 0;
                    for (Map<String, int> element in item!.food) {
                      foodSumm = foodSumm + element.values.first;
                    }
                    for (Map<String, int> element in item.expenditure) {
                      expendSumm = expendSumm + element.values.first;
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return CaloriesDetails(
                                data: item,
                              );
                            },
                          ),
                        );
                      },
                      child: _topContainer(
                        'Calories',
                        '${(foodSumm - expendSumm).toInt()} kcal',
                        shrinkPercentage,
                        circularChart(
                          foodSumm,
                          expendSumm,
                          '60%',
                          context,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: method.hSizeCalc(20),
                ),
                ValueListenableBuilder(
                  valueListenable: config.daylyData,
                  builder: (context, value, _) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const FatDetails();
                            },
                          ),
                        );
                      },
                      child: _topContainer(
                        'Fat',
                        getDifference(),
                        shrinkPercentage,
                        cartesianChart(
                          max(1.5, 3.32 * (1 - shrinkPercentage)),
                          max(0.45, 0.9 * (1 - shrinkPercentage)),
                          method.getChartFatData(),
                          context,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calculate',
                        style: TextStyle(
                          fontSize: 32,
                          color: colors.mainColor,
                          height: 0.38,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const CalculatePage();
                              },
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: colors.redColor,
                          foregroundColor: Colors.white,
                          maximumSize: Size(method.hSizeCalc(74), 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10 + (20 * (1 - shrinkPercentage)),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: tabGraphPageIndex,
                    builder: (context, value, widget) {
                      return customTabBar(
                        'Calories',
                        'Fat',
                        graphPageTabController,
                        tabGraphPageIndex,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getDifference() {
    List data = method.getChartFatData();
    if (data.isNotEmpty) {
      var dif = data.last.x - data.first.x;
      if (dif > 0) {
        return '+${config.f.format(dif)} %';
      } else {
        return '${config.f.format(dif)} %';
      }
    } else {
      return 'No data';
    }
  }

  Widget _topContainer(
    String labelText,
    String bottomText,
    double shrinkPercentage,
    Widget containWidget,
  ) {
    double progress = 1 - shrinkPercentage;
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: method.vSizeCalc(10),
              horizontal: method.hSizeCalc(12),
            ),
            width: method.hSizeCalc(165) - 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10 + (10 * progress),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.centerLeft,
                      pow(shrinkPercentage, 3).toDouble(),
                    ),
                    child: Text(
                      labelText,
                      style: TextStyle.lerp(
                        const TextStyle(
                          fontSize: 21,
                          height: 1.71,
                        ),
                        const TextStyle(
                          fontSize: 21,
                          height: 1,
                        ),
                        pow(progress, 5).toDouble(),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.lerp(
                      Alignment.centerRight,
                      Alignment.center,
                      pow(progress, 5).toDouble(),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: method.vSizeCalc(77),
                        maxWidth: method.hSizeCalc(81),
                        minHeight: method.vSizeCalc(77) / 3,
                        minWidth: method.hSizeCalc(81) / 3,
                      ),
                      width: method.hSizeCalc(81) * (progress),
                      height: method.vSizeCalc(77) * (progress),
                      child: containWidget,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Opacity(
                        opacity: pow(progress, 3).toDouble(),
                        child: Text(
                          bottomText,
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.greyColor,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 265 + (method.hSizeCalc(165)-50);

  @override
  double get minExtent => isScrollable ? 200 : currentSize;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

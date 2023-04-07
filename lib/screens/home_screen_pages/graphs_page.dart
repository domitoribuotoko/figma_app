import 'dart:math';

import 'package:figma_app/base/app_widgets.dart';
import 'package:figma_app/screens/home_screen_pages/calculate_page.dart';
import 'package:flutter/material.dart';

import '../../base/app_constans.dart';
import '../../base/app_methods.dart';

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
                              6,
                              (index) {
                                return _caloriesTabContainer();
                              },
                            ),
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
                              4,
                              (index) => _fatTabContainer(index),
                            ),
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

  Widget _caloriesTabContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '02.03.2023',
                style: tS.grey16TS1,
              ),
              Text(
                '1067 kcal',
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
                      '2394 kcal',
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
                      '-1327 kcal',
                      style: tS.grey20TS1,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _fatTabContainer(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: index == 3 ? 0 : 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '02.03.2023',
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
              vertical: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '-fat. %',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.05,
                      ),
                    ),
                    Text(
                      '-0,5 % %',
                      style: TextStyle(
                        fontSize: 20,
                        color: colors.greyColor,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
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
                _topContainer(
                  'Calories',
                  '1067 kcal',
                  shrinkPercentage,
                  circularChart(),
                ),
                SizedBox(
                  width: method.hSizeCalc(20),
                ),
                _topContainer(
                  'Fat',
                  '-0.5%',
                  shrinkPercentage,
                  cartesianChart(3),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10 + (40 * (1 - shrinkPercentage)),
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
                          minimumSize: Size(method.hSizeCalc(74), 50),
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
                      return Row(
                        children: [
                          tabButton(
                            ontap: () {
                              graphPageTabController.animateTo(
                                0,
                              );
                              tabGraphPageIndex.value = 0;
                            },
                            buttonColor: tabGraphPageIndex.value == 0 ? colors.mainColor : Colors.white,
                            text: 'Calories',
                            textColor: tabGraphPageIndex.value != 0 ? colors.mainColor : Colors.white,
                          ),
                          SizedBox(
                            width: method.hSizeCalc(20),
                          ),
                          tabButton(
                            ontap: () {
                              graphPageTabController.animateTo(
                                1,
                              );
                              tabGraphPageIndex.value = 1;
                            },
                            buttonColor: tabGraphPageIndex.value == 1 ? colors.mainColor : Colors.white,
                            text: 'Fat',
                            textColor: tabGraphPageIndex.value != 1 ? colors.mainColor : Colors.white,
                          ),
                        ],
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
                        opacity: progress * progress * progress,
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
  double get maxExtent => 390;

  @override
  double get minExtent => isScrollable ? 200 : currentSize;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

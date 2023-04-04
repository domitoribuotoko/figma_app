import 'dart:math';

import 'package:flutter/material.dart';

import '../../base/app_constans.dart';
import '../../base/app_methods.dart';
import '../../base/app_widgets.dart';

late TabController _tabController;
final ValueNotifier<int> _tabIndex = ValueNotifier<int>(0);

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: CustomSliverAppBar(),
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 210),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            CustomScrollView(
              slivers: [
                // SliverOverlapInjector(
                //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                // ),
                SliverToBoxAdapter(
                  child: Column(
                    children: List<Widget>.generate(
                      100,
                      (index) => Text(index == 0
                          ? 'start'
                          : index == 99
                              ? 'end'
                              : 'tab 1 item $index'),
                    ),
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                return CustomScrollView(
                  slivers: [
                    // SliverOverlapInjector(
                    //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: List<Widget>.generate(
                          40,
                          (index) => Text(index == 0
                              ? 'start'
                              : index == 39
                                  ? 'end'
                                  : 'tab 2 item $index'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget topContainer(String labelText, String value, Widget contain, double progress) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10 + (10 * progress)),
    ),
    padding: EdgeInsets.symmetric(
      vertical: method.vSizeCalc(10),
      horizontal: method.hSizeCalc(12),
    ),
    constraints: BoxConstraints.tightFor(
      width: method.hSizeCalc(165),
      height: max(50, method.hSizeCalc(165) * progress),
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            alignment: Alignment.lerp(
              Alignment.topCenter,
              Alignment.topLeft,
              progress,
            ),
            child: Text(
              labelText,
              textAlign: TextAlign.center,
              style: TextStyle.lerp(
                const TextStyle(
                  fontSize: 21,
                  height: 1.5,
                ),
                const TextStyle(
                  fontSize: 21,
                  height: 1,
                ),
                progress,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            alignment: Alignment.lerp(
              Alignment.centerRight,
              Alignment.center,
              progress * progress,
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
                child: contain),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Opacity(
                opacity: progress * progress * progress,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff4E4E4E),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget tabButton({
  required Function() ontap,
  required Color buttonColor,
  required Color textColor,
  required String text,
}) {
  return TextButton(
    onPressed: ontap,
    style: TextButton.styleFrom(
      backgroundColor: buttonColor,
      foregroundColor: Colors.white.withOpacity(0.8),
      minimumSize: Size(method.hSizeCalc(165), 41),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: textColor,
      ),
    ),
  );
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 397.4 + 29;

  @override
  double get minExtent => 230;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double progress = 1 - min(1, shrinkOffset / (maxExtent - minExtent));
    // print(shrinkOffset);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: method.hSizeCalc(20),
            right: method.hSizeCalc(20),
            top: 40 + (35 * progress),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  topContainer(
                    'Calories',
                    '1067 kcal',
                    circularChart(),
                    progress,
                  ),
                  SizedBox(
                    width: method.hSizeCalc(20),
                  ),
                  topContainer(
                    'Fat',
                    '-0.5%',
                    cartesianChart(1 + (2 * progress)),
                    progress,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10 + (40 * progress),
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
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: colors.redColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(method.hSizeCalc(74), 41),
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
                padding: EdgeInsets.only(top: 10 + (10 * progress)),
                child: ValueListenableBuilder(
                  valueListenable: _tabIndex,
                  builder: (context, value, _) {
                    return Row(
                      children: [
                        tabButton(
                          ontap: () {
                            _tabController.animateTo(0);
                            _tabIndex.value = 0;
                          },
                          buttonColor: _tabIndex.value == 0 ? colors.mainColor : Colors.white,
                          text: 'Calories',
                          textColor: _tabIndex.value == 0 ? Colors.white : colors.mainColor,
                        ),
                        SizedBox(
                          width: method.hSizeCalc(20),
                        ),
                        tabButton(
                          ontap: () {
                            _tabController.animateTo(1);
                            _tabIndex.value = 1;
                          },
                          buttonColor: _tabIndex.value == 1 ? colors.mainColor : Colors.white,
                          text: 'Fat',
                          textColor: _tabIndex.value == 1 ? Colors.white : colors.mainColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 20,
            maxWidth: metrix.screenWidth,
          ),
          decoration: BoxDecoration(
            // color: Colors.red,
            gradient: LinearGradient(
              begin: const Alignment(0, -0.7),
              end: Alignment.bottomCenter,
              colors: [
                colors.mainBackgrounColor,
                colors.mainBackgrounColor.withOpacity(0),
              ],
            ),
          ),
          height: 20,
          width: metrix.screenWidth,
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

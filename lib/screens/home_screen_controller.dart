import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/screens/home_screen_pages/dummy_json.dart';
import 'package:figma_app/screens/home_screen_pages/exercise_page.dart';
import 'package:figma_app/screens/home_screen_pages/graphs_page.dart';
import 'package:figma_app/screens/home_screen_pages/article_video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../base/app_config.dart';
import '../base/app_methods.dart';

class HomeScreenController extends StatefulWidget {
  const HomeScreenController({super.key});

  @override
  State<HomeScreenController> createState() => _HomeScreenControllerState();
}

class _HomeScreenControllerState extends State<HomeScreenController> {
  final PageController _pageController = PageController(initialPage: 1);
  final ValueNotifier<int> _activePage = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      body: SafeArea(
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: 4,
          onPageChanged: (value) {
            _activePage.value = value;
          },
          itemBuilder: (context, index) {
            return [
              // ignore: prefer_const_constructors
              ExercisePage(),
               // ignore: prefer_const_constructors
              GraphsPage(),
               // ignore: prefer_const_constructors
              ArticlesVideosPage(),
               // ignore: prefer_const_constructors
              DummyJson(),
            ].elementAt(index);
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _activePage,
        builder: (context, value, _) {
          return Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedLabelStyle: const TextStyle(
                height: 1,
                fontSize: 14,
              ),
              currentIndex: _activePage.value,
              // iconSize: 0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: (value) {
                _pageController.jumpToPage(
                  value,
                  // duration: const Duration(milliseconds: 200),
                  // curve: Curves.fastOutSlowIn,
                );
              },
              items: [
                bottomBarItem(ipath.awardSvg),
                bottomBarItem(ipath.graphsSvg),
                bottomBarItem(ipath.calendarSvg),
                bottomBarItem(ipath.dummy),
              ],
            ),
          );
        },
      ),
    );
  }

  List<FatData> getChartFatData() {
    List<FatData> data = [];
    for (var element in config.box.values) {
      if (element.fat != null) {
        data.add(
          FatData(
            element.fat!.bodyFatPercentage,
            element.date,
          ),
        );
      }
    }
    return data;
  }
}

BottomNavigationBarItem bottomBarItem(String svg) {
  return BottomNavigationBarItem(
    label: '',
    icon: Container(
      padding: EdgeInsets.symmetric(
        vertical: method.vSizeCalc(15),
        horizontal: method.hSizeCalc(15),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        svg,
      ),
    ),
    activeIcon: Container(
      padding: EdgeInsets.symmetric(
        vertical: method.vSizeCalc(15),
        horizontal: method.hSizeCalc(15),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        svg,
      ),
    ),
  );
}

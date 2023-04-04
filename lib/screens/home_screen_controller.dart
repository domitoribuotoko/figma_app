import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:figma_app/screens/home_screen_pages/graphs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: 3,
        onPageChanged: (value) {
          _activePage.value = value;
        },
        itemBuilder: (context, index) {
          return [
            SafeArea(
              child: Container(),
            ),
            const SafeArea(child: GraphsPage()),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: SafeArea(
                child: Center(
                  child: cartesianChart(5),
                ),
              ),
            ),
          ].elementAt(index);
        },
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
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _activePage.value,
              iconSize: 0,
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
                bottomBarItem(ipath.grapsSvg),
                bottomBarItem(ipath.calendarSvg),
              ],
            ),
          );
        },
      ),
    );
  }
}

BottomNavigationBarItem bottomBarItem(String svg) {
  return BottomNavigationBarItem(
    label: '',
    icon: SvgPicture.asset(
      svg,
    ),
    activeIcon: Container(
      padding: EdgeInsets.symmetric(vertical: method.vSizeCalc(15), horizontal: method.hSizeCalc(15)),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SvgPicture.asset(
        svg,
      ),
    ),
  );
}

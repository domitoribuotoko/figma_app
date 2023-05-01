
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/screens/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StartPagesController extends StatefulWidget {
  const StartPagesController({super.key});

  @override
  State<StartPagesController> createState() => _StartPagesControllerState();
}

class _StartPagesControllerState extends State<StartPagesController> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _activePage = ValueNotifier<int>(0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    metrix.mediaQueryData = MediaQuery.of(context);
    metrix.screenHeight = metrix.mediaQueryData.size.height;
    metrix.screenWidth = metrix.mediaQueryData.size.width;
    metrix.statusBarHeight = metrix.mediaQueryData.padding.top;
    metrix.bottomNavBarHeight = method.vSizeCalc(30) + 35 + 28;
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      body: Stack(
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: 2,
            onPageChanged: (value) {
              _activePage.value = value;
            },
            itemBuilder: (context, index) {
              return [
                StarPage(
                  callback: animateToPage,
                ),
                DumbellPage(
                  callback: showSheet,
                ),
              ].elementAt(index);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: method.vSizeCalc(602)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                2,
                (index) {
                  return ValueListenableBuilder<int>(
                    valueListenable: _activePage,
                    builder: (context, value, _) {
                      return Container(
                        margin: index == 0 ? const EdgeInsets.only(right: 10) : null,
                        width: 50,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _activePage.value == index ? colors.mainColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  showSheet() async {
    await showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: method.vSizeCalc(425),
        maxWidth: metrix.screenWidth,
      ),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(35),
        ),
      ),
      builder: (context) {
        return const BottomAttentionSheet();
      },
    );
  }
}

class StarPage extends StatelessWidget {
  final Function(int) callback;
  const StarPage({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colors.mainBackgrounColor,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: method.vSizeCalc(200),
                bottom: method.vSizeCalc(100),
              ),
              child: Image(
                height: method.vSizeCalc(200),
                image: AssetImage(
                  ppath.starPng,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: method.vSizeCalc(125),
              ),
              child: Text(
                'Be the first',
                style: tS.main36TS,
              ),
            ),
            TextButton(
              onPressed: () {
                callback(1);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(174, 82),
              ),
              child: Text(
                'Next',
                style: tS.black36TS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DumbellPage extends StatelessWidget {
  final Function() callback;
  const DumbellPage({
    super.key,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colors.mainBackgrounColor,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: method.vSizeCalc(266),
                bottom: method.vSizeCalc(100),
              ),
              child: Image(
                height: method.vSizeCalc(134),
                image: AssetImage(
                  ppath.dumbbPng,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: method.vSizeCalc(125),
              ),
              child: Text(
                'Take care of yourself',
                style: tS.main36TS,
              ),
            ),
            TextButton(
              onPressed: () {
                callback();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(178, 82),
              ),
              child: Text(
                'Start',
                style: tS.black36TS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomAttentionSheet extends StatelessWidget {
  const BottomAttentionSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: method.hSizeCalc(20),
        right: method.hSizeCalc(20),
        top: method.vSizeCalc(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: method.hSizeCalc(24),
              ),
              Text(
                'Attention',
                style: tS.main36TS,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  ipath.closeSvg,
                ),
              ),
            ],
          ),
          Text(
            longString.attentionText,
            style: TextStyle(
              fontSize: 16,
              height: 1.7 * method.ratio(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: method.vSizeCalc(41)),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return const HomeScreenController();
                  },
                ), (route) => false);
              },
              style: TextButton.styleFrom(
                backgroundColor: colors.mainBackgrounColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: Size(method.hSizeCalc(178), method.vSizeCalc(82)),
              ),
              child: Text(
                'Start',
                style: tS.main36TS,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

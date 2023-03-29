import 'package:figma_app/base/app_constans.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            // physics: const NeverScrollableScrollPhysics(),
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
            padding: EdgeInsets.only(top: AppMetrix().screenHeight * .713270),
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
                          color: _activePage.value == index ? AppColors().mainColor : Colors.white,
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

  showSheet() {
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: AppMetrix().screenHeight * .503554,
        maxWidth: AppMetrix().screenWidth,
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
      backgroundColor: AppColors().mainBackgrounColor,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: AppMetrix().screenHeight * .236966,
                bottom: AppMetrix().screenHeight * .118483,
              ),
              child: const Image(
                height: 200,
                image: AssetImage(
                  'lib/assets/images/star_and_ribbon.png',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: AppMetrix().screenHeight * .148104,
              ),
              child: Text(
                'Be the first',
                style: AppTextStyles().mainTextStyle,
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
                style: AppTextStyles().blackMainTextStyle,
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
      backgroundColor: AppColors().mainBackgrounColor,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: AppMetrix().screenHeight * .315165,
                bottom: AppMetrix().screenHeight * .118483,
              ),
              child: const Image(
                height: 134,
                image: AssetImage(
                  'lib/assets/images/pink_dumbbell.png',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: AppMetrix().screenHeight * .148104,
              ),
              child: Text(
                'Take care of yourself',
                style: AppTextStyles().mainTextStyle,
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
                style: AppTextStyles().blackMainTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomAttentionSheet extends StatelessWidget {
  const BottomAttentionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 24,
              ),
              Text(
                'Attention',
                style: AppTextStyles().mainTextStyle,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  'lib/assets/svg/vector.svg',
                ),
              ),
            ],
          ),
          Text(
            AppLongStrings().attentionText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: AppMetrix().screenHeight * .048578),
            child: TextButton(
              onPressed: () {
                // callback();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors().mainBackgrounColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(178, 82),
              ),
              child: Text(
                'Start',
                style: AppTextStyles().mainTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

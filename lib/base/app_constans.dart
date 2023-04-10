import 'package:flutter/material.dart';

class AppColors {
  final Color mainColor = const Color(0xff2C324A);
  final Color mainBackgrounColor = const Color(0xffC9F8FF);
  final Color redColor = const Color(0xffE55C59);
  final Color circularGradientStart = const Color(0xffFED17B);
  final Color circularGradientEnd = const Color(0xffFFA800);
  final Color cartesianGradient = const Color(0xff547AFF);
  final Color greyColor = const Color(0xff4E4E4E);
  final Color lightGreyColor = const Color(0xffD1CDCD);
}

final colors = AppColors();

class AppTextStyles {
  final TextStyle main36TS = TextStyle(
    color: colors.mainColor,
    fontSize: 36,
  );

  final TextStyle black36TS = const TextStyle(
    color: Colors.black,
    fontSize: 36,
  );
  final TextStyle main32TS = TextStyle(
    color: colors.mainColor,
    fontSize: 32,
  );
  final TextStyle grey20TS1 = TextStyle(
    fontSize: 20,
    color: colors.greyColor,
    height: 1,
  );
  final TextStyle main20TS = TextStyle(
    fontSize: 20,
    color: colors.mainColor,
  );
  final TextStyle grey16TS1 = TextStyle(
    fontSize: 16,
    color: colors.greyColor,
    height: 1,
  );
}

final tS = AppTextStyles();

class AppMetrix {
  late MediaQueryData mediaQueryData;
  late double screenHeight;
  late double screenWidth;
  late double statusBarHeight;
  late double bottomNavBarHeight;
}

final metrix = AppMetrix();

class AppLongStrings {
  final String attentionText =
      'The content in our app is not medical advice or a substitute for professional medical care, diagnosis or treatment. Your doctor will determine your specific needs and advise you personally during consultations on what medication to take.';
}

final longString = AppLongStrings();

class AppIconsPaths {
  final String closeSvg = 'lib/assets/svg/close.svg';
  final String awardSvg = 'lib/assets/svg/award.svg';
  final String graphsSvg = 'lib/assets/svg/graphs.svg';
  final String calendarSvg = 'lib/assets/svg/calendar.svg';
  final String backArrow = 'lib/assets/svg/back_arrow.svg';
  final String checkMark = 'lib/assets/svg/check.svg';
  final String uncheckMark = 'lib/assets/svg/uncheck.svg';
  final String fireIcon = 'lib/assets/svg/fire.svg';
}

final ipath = AppIconsPaths();

class AppPngPaths {
  final String starPng = 'lib/assets/images/star_and_ribbon.png';
  final String dumbbPng = 'lib/assets/images/pink_dumbbell.png';
}

final ppath = AppPngPaths();

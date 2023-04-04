import 'package:flutter/material.dart';

class AppColors {
  final Color mainColor = const Color(0xff2C324A);
  final Color mainBackgrounColor = const Color(0xffC9F8FF);
  final Color redColor = const Color(0xffE55C59);
  final Color circularGradientStart = const Color(0xffFED17B);
  final Color circularGradientEnd = const Color(0xffFFA800);
  final Color cartesianGradient = const Color(0xff547AFF);
}

final colors = AppColors();

class AppTextStyles {
  final TextStyle mainTextStyle = const TextStyle(
    color: Color(0xff2C324A),
    fontSize: 36,
  );

  final TextStyle blackMainTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 36,
  );
}

final textStyles = AppTextStyles();

class AppMetrix {
  late double screenHeight;
  late double screenWidth;
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
  final String grapsSvg = 'lib/assets/svg/graphs.svg';
  final String calendarSvg = 'lib/assets/svg/calendar.svg';
}

final ipath = AppIconsPaths();

class AppPngPaths {
  final String starPng = 'lib/assets/images/star_and_ribbon.png';
  final String dumbbPng = 'lib/assets/images/pink_dumbbell.png';
}

final ppath = AppPngPaths();

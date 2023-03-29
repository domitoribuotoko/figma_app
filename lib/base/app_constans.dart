import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  final Color mainColor = const Color(0xff2C324A);
  final Color mainBackgrounColor = const Color(0xffC9F8FF);
}

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

class AppMetrix {
  final double screenHeight = Get.height;
  final double screenWidth = Get.width;
}

class AppLongStrings {
  final String attentionText =
      'The content in our app is not medical advice or a substitute for professional medical care, diagnosis or treatment. Your doctor will determine your specific needs and advise you personally during consultations on what medication to take.';
}

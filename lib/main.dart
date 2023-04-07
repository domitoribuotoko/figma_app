import 'package:figma_app/screens/start_pages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base/app_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await method.getPackageInfo();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Baloo_Bhaijaan_2',
      ),
      debugShowCheckedModeBanner: false,
      home: const StartPagesController(),
    );
  }
}

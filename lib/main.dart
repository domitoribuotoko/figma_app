import 'package:figma_app/screens/start_pages_controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Baloo_Bhaijaan_2'),
      debugShowCheckedModeBanner: false,
      home: const StartPagesController(),
    );
  }
}

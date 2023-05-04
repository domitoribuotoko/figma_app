import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/generated/codegen_loader.g.dart';
import 'package:figma_app/screens/start_pages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'base/app_methods.dart';
import 'package:intl/date_symbol_data_local.dart' as intl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await intl.initializeDateFormatting();
  await method.initSp();
  await method.getHiveList();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    EasyLocalization(
      supportedLocales: List<Locale>.generate(
        config.availableTranslations.length,
        (index) => Locale(config.availableTranslations.keys.elementAt(index)),
      ),
      path: 'lib/assets/translations',
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        fontFamily: 'Baloo_Bhaijaan_2',
      ),
      debugShowCheckedModeBanner: false,
      home: const StartPagesController(),
    );
  }
}

import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';

import '../../../base/app_config.dart';
import '../../../base/app_constans.dart';

class FatSettings extends StatefulWidget {
  const FatSettings({super.key});

  @override
  State<FatSettings> createState() => _FatSettingsState();
}

class _FatSettingsState extends State<FatSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, 'Fat Settings', false),
      backgroundColor: colors.mainBackgrounColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: config.fatSettings,
            builder: (context, value, _) {
              return Switch(
                value: config.fatSettings.value,
                onChanged: (value) async {
                  await method.fatSettingsSet(!config.sharedPreferences.getBool('fatSettings')!);
                  config.fatSettings.value = config.sharedPreferences.getBool('fatSettings')!;
                },
                activeColor: colors.redColor,
              );
            },
          ),
          Text(
            'Show Empty Fat Data',
            style: tS.main20TS,
          ),
        ],
      ),
    );
  }
}

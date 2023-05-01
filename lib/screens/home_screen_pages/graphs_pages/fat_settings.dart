import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';

import '../../../base/app_config.dart';
import '../../../base/app_constans.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, 'Settings', false),
      backgroundColor: colors.mainBackgrounColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: method.hSizeCalc(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                  valueListenable: config.isShowFakeData,
                  builder: (context, value, _) {
                    return Switch(
                      value: config.isShowFakeData.value,
                      onChanged: (value) async {
                        await method.fakeDataSet(!config.sharedPreferences.getBool('showFakeData')!);
                        config.isShowFakeData.value = config.sharedPreferences.getBool('showFakeData')!;
                      },
                      activeColor: colors.redColor,
                    );
                  },
                ),
                Text(
                  'Show Fake Data',
                  style: tS.main20TS,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

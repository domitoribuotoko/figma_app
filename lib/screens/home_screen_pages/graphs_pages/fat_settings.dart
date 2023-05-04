import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:figma_app/generated/locale_keys.g.dart';
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
      appBar: defaultAppBar(context, LocaleKeys.settings.tr(), false),
      backgroundColor: colors.mainBackgrounColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: method.hSizeCalc(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    LocaleKeys.showEmptyFatData.tr(),
                    style: tS.main20TS,
                  ),
                ),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.showFakeData.tr(),
                  style: tS.main20TS,
                ),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.language.tr(),
                  style: tS.main20TS,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: colors.redColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                      iconEnabledColor: Colors.white,
                    ),
                    dropdownStyleData: const DropdownStyleData(),
                    // value: context.locale.toString(),
                    hint: Text(
                      config.availableTranslations[context.locale.toString()]!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    items: List<DropdownMenuItem>.generate(
                      config.availableTranslations.length,
                      (index) {
                        return DropdownMenuItem(
                          value: config.availableTranslations.keys.elementAt(index),
                          child: Text(
                            config.availableTranslations.values.elementAt(index),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    onChanged: (value) async {
                      await context.setLocale(Locale(value));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

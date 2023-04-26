import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';

class FatDetails extends StatefulWidget {
  const FatDetails({super.key});

  @override
  State<FatDetails> createState() => _FatDetailsState();
}

class _FatDetailsState extends State<FatDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      appBar: defaultAppBar(context, 'Fat', true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  child: SizedBox(
                    width: method.hSizeCalc(262),
                    height: method.hSizeCalc(262),
                    child: cartesianChart(
                      method.hSizeCalc(9),
                      2,
                      method.getChartFatData(),context,
                    ),
                  ),
                ),
              ],
            ),
            ...List<Widget>.generate(
              config.box.length,
              (index) => daylyFatContainer(index),
            ).reversed,
          ],
        ),
      ),
    );
  }

  daylyFatContainer(int index) {
    var item = config.box.getAt(index);
    Fat? fat = item!.fat;

    return ValueListenableBuilder(
        valueListenable: config.fatSettings,
        builder: (context, value, _) {
          return Visibility(
            visible: fat != null ? true : config.fatSettings.value,
            child: Padding(
              padding: EdgeInsets.only(
                left: method.hSizeCalc(20),
                right: method.hSizeCalc(20),
                bottom: 30,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        method.dateFormat(item.date),
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.greyColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: method.hSizeCalc(20)),
                    child: fat != null
                        ? Column(
                            children: [
                              rowFatDetails('Body fat percentage', '${config.f.format(fat.bodyFatPercentage)} %'),
                              rowFatDetails('Fat mass', '${config.f.format(fat.fatMass)} kg'),
                              rowFatDetails('Mass without fat', '${config.f.format(fat.massWithoutFat)} kg'),
                              rowFatDetails('Category', fat.category),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No this day fat data',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: colors.greyColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  rowFatDetails(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: tS.black20TS,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: colors.greyColor,
          ),
        ),
      ],
    );
  }
}

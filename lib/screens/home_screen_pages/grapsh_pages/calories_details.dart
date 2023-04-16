import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/app_methods.dart';

class CaloriesDetails extends StatefulWidget {
  final AppDaylyData data;
  const CaloriesDetails({
    super.key,
    required this.data,
  });

  @override
  State<CaloriesDetails> createState() => _CaloriesDetailsState();
}

class _CaloriesDetailsState extends State<CaloriesDetails> {
  double foodSumm = 0;
  double expendSumm = 0;

  @override
  void initState() {
    getCalories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      appBar: defaultAppBar(context, 'Calories'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        // color: Colors.red,
                        width: method.hSizeCalc(262),
                        height: method.hSizeCalc(262),
                        child: circularChart(
                          foodSumm,
                          expendSumm,
                          '77%',
                        ),
                      ),
                      SizedBox(
                        height: 57.5,
                        width: 69.1,
                        child: SvgPicture.asset(
                          ipath.fireIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              margin: EdgeInsets.symmetric(horizontal: method.hSizeCalc(20)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          method.dateFormat(widget.data.date),
                          style: tS.grey16TS1,
                        ),
                        Text(
                          '${foodSumm - expendSumm} kcal',
                          style: tS.grey16TS1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: method.hSizeCalc(20)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: getDetailedContainer(
                            widget.data.food,
                            'Food',
                          ),
                        ),
                        getDetailedContainer(
                          widget.data.expenditure,
                          'Expenditure',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCalories() {
    for (Map<String, int> element in widget.data.food) {
      foodSumm = foodSumm + element.values.first;
    }
    for (Map<String, int> element in widget.data.expenditure) {
      expendSumm = expendSumm + element.values.first;
    }
  }
}

Widget getDetailedContainer(List<Map<String, int>> data, String name) {
  double summCalories = 0;

  for (var i = 0; i < data.length; i++) {
    summCalories = summCalories + data[i].values.first;
  }

  String getSumm() {
    if (name == 'Food') {
      return '${summCalories.toInt()} kcal';
    } else {
      return '-${summCalories.toInt()} kcal';
    }
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: tS.black20TS,
            ),
            Text(
              getSumm(),
              style: TextStyle(
                color: colors.greyColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      ...List<Widget>.generate(
        data.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            left: method.hSizeCalc(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data[index].keys.first,
                style: tS.black20TS,
              ),
              Text(
                '${data[index].values.first} kcal',
                style: TextStyle(
                  color: colors.greyColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}

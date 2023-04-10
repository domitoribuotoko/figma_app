import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../base/app_config.dart';
import '../../../base/app_methods.dart';

class CaloriesDetails extends StatefulWidget {
  const CaloriesDetails({super.key});

  @override
  State<CaloriesDetails> createState() => _CaloriesDetailsState();
}

class _CaloriesDetailsState extends State<CaloriesDetails> {
  var item = config.box.value.get(method.dateToKey());
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 30,
                color: Colors.transparent,
                margin: EdgeInsets.only(
                  left: method.hSizeCalc(25),
                  right: method.hSizeCalc(10),
                ),
                child: SvgPicture.asset(
                  ipath.backArrow,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Text(
              'Calories',
              style: tS.main32TS,
            ),
          ],
        ),
      ),
      body: Column(
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
                      child: circularChart(foodSumm, expendSumm, '77%'),
                    ),
                    SizedBox(
                      height: 57.5,
                      width: 69.1,
                      child: SvgPicture.asset(ipath.fireIcon),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  getCalories() {
    for (Map<String, int> element in item!.food) {
      foodSumm = foodSumm + element.values.first;
    }
    for (Map<String, int> element in item!.expenditure) {
      expendSumm = expendSumm + element.values.first;
    }
  }
}

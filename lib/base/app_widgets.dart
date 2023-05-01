import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/screens/home_screen_pages/graphs_pages/fat_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_classes.dart';
import 'app_methods.dart';

Widget circularChart(double maxValue, double expenditure, String innerRadius, BuildContext context) {
  List<CaloriesValue> data = [
    CaloriesValue(
      '',
      expenditure,
    ),
  ];

  CornerStyle setCurves() {
    double degreeEnd = 360 * (data[0].calories / maxValue);
    return degreeEnd < 12
        ? CornerStyle.bothFlat
        : degreeEnd >= 360
            ? CornerStyle.bothFlat
            : CornerStyle.endCurve;
  }

  return SfCircularChart(
    margin: const EdgeInsets.all(0),
    onCreateShader: (chartShaderDetails) {
      return method.setSweepGradienForCircularChart(chartShaderDetails, data[0], maxValue);
    },
    series: <CircularSeries>[
      RadialBarSeries<CaloriesValue, String>(
        radius: '100%',
        strokeColor: Colors.blue,
        animationDuration: 0,
        dataSource: data,
        xValueMapper: (CaloriesValue data, _) => data.x,
        yValueMapper: (CaloriesValue data, _) => data.calories,
        maximumValue: data[0].calories.toDouble() > maxValue ? data[0].calories.toDouble() : maxValue,
        cornerStyle: setCurves(),
        innerRadius: innerRadius,
        trackColor: colors.lightGreyColor,
      ),
    ],
  );
}

Widget cartesianChart(
  double size,
  double borderWidth,
  List<FatData> getChartFatData,
  BuildContext context,
  bool isDetailed,
) {
  double maxValue() {
    final List<double> values = [];
    if (isDetailed) {
      for (var element in getChartFatData) {
        values.add(element.x);
      }
    } else {
      for (var i = getChartFatData.length - 1; i > -1; i--) {
        if (values.length < 7) {
          values.add(getChartFatData[i].x);
        } else {
          break;
        }
      }
    }
    values.sort();
    return values.last;
  }

  if (getChartFatData.isEmpty || getChartFatData.length < 3) {
    getChartFatData = [
      FatData(1.5, DateTime.now()),
      FatData(2, DateTime.now().subtract(const Duration(days: -1))),
      FatData(1.5, DateTime.now().subtract(const Duration(days: -2))),
      // FatData(2.3, DateTime.now().subtract(const Duration(days: -3))),
    ];
  }

  DateTime getVisibleMinimum() {
    if (getChartFatData.length < 7) {
      return getChartFatData[0].t;
    } else {
      return DateTime.now().subtract(const Duration(days: 6));
    }
  }

  List<SplineAreaSeries<FatData, dynamic>> getDefaultData(double size, double borderWidth) {
    return <SplineAreaSeries<FatData, dynamic>>[
      SplineAreaSeries<FatData, dynamic>(
        dataSource: getChartFatData,
        xValueMapper: (FatData sales, _) => sales.t,
        yValueMapper: (FatData sales, _) => sales.x,
        yAxisName: 'Date',
        splineType: SplineType.monotonic,
        gradient: LinearGradient(
          colors: [colors.cartesianGradient, colors.cartesianGradient.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        animationDuration: 0,
        borderDrawMode: BorderDrawMode.top,
        markerSettings: MarkerSettings(
          isVisible: true,
          borderColor: const Color(0xff88a2ff),
          color: Colors.white,
          height: size,
          width: size,
          borderWidth: borderWidth,
        ),
      ),
    ];
  }

  return SfCartesianChart(
    margin: const EdgeInsets.all(0),
    series: getDefaultData(size, borderWidth),
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: isDetailed,
      zoomMode: ZoomMode.x,
    ),
    primaryXAxis: DateTimeAxis(
      isVisible: false,
      // visibleMaximum: DateTime.now(),
      interval: 1,
      intervalType: DateTimeIntervalType.days,
      visibleMinimum: getVisibleMinimum(),
      axisLine: const AxisLine(
        width: 0,
      ),
    ),
    primaryYAxis: NumericAxis(
      anchorRangeToVisiblePoints: false,
      visibleMaximum: maxValue(),
      // interval: 1,
      isVisible: false,
      axisLine: const AxisLine(
        width: 0,
      ),
    ),
    plotAreaBorderWidth: 0,
    // enableAxisAnimation: true,
    // onMarkerRender: (MarkerRenderArgs args) {
    //   if (!(args.pointIndex == 2)) {
    //     args.markerHeight = 0.0;
    //     args.markerWidth = 0.0;
    //   }
    // },
  );
}

Widget tabButton({
  required Function() ontap,
  required Color buttonColor,
  required Color textColor,
  required String text,
}) {
  return TextButton(
    onPressed: ontap,
    style: TextButton.styleFrom(
      backgroundColor: buttonColor,
      foregroundColor: Colors.white.withOpacity(0.8),
      minimumSize: Size(method.hSizeCalc(165), 50),
      // maximumSize:  const Size(165, 41),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: textColor,
      ),
    ),
  );
}

Widget formField({
  required String fieldName,
  String hintText = 'Numeric',
  required Function(String?) onSaved,
  required String? Function(String?) validator,
  List<TextInputFormatter>? inputFormatters,
  String type = 'cm',
}) {
  return Padding(
    padding: EdgeInsets.only(
      left: method.hSizeCalc(20),
      right: method.hSizeCalc(20),
      bottom: 30,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: tS.main20TS,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: method.hSizeCalc(10)),
                child: Text(
                  type,
                  style: tS.grey16TS1,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
              hintText: hintText,
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              border: InputBorder.none,
              errorStyle: const TextStyle(
                fontSize: 0,
                height: 1,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: colors.greyColor,
            ),
            onSaved: onSaved,
            validator: validator,
          ),
        ),
      ],
    ),
  );
}

PreferredSizeWidget defaultAppBar(context, String title, bool showSettings) {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    titleSpacing: 0,
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
          title,
          style: tS.main32TS,
        ),
      ],
    ),
    actions: [
      Visibility(
        visible: showSettings,
        child: Padding(
          padding: const EdgeInsets.only(right: 7),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const Settings();
                  },
                ),
              );
            },
            splashRadius: 1,
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget customTabBar(String leftTitle, String rightTitle, TabController controller, ValueNotifier<int> pageIndex) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      tabButton(
        ontap: () {
          controller.animateTo(
            0,
          );
          pageIndex.value = 0;
        },
        buttonColor: pageIndex.value == 0 ? colors.mainColor : Colors.white,
        text: leftTitle,
        textColor: pageIndex.value != 0 ? colors.mainColor : Colors.white,
      ),
      SizedBox(
        width: method.hSizeCalc(20),
      ),
      tabButton(
        ontap: () {
          controller.animateTo(
            1,
          );
          pageIndex.value = 1;
        },
        buttonColor: pageIndex.value == 1 ? colors.mainColor : Colors.white,
        text: rightTitle,
        textColor: pageIndex.value != 1 ? colors.mainColor : Colors.white,
      ),
    ],
  );
}

class PlaceHolderSkeletonWidget extends StatefulWidget {
  const PlaceHolderSkeletonWidget({super.key});

  @override
  State<PlaceHolderSkeletonWidget> createState() => _PlaceHolderSkeletonWidgetState();
}

class _PlaceHolderSkeletonWidgetState extends State<PlaceHolderSkeletonWidget> with TickerProviderStateMixin {
  late AnimationController aC1;
  late AnimationController aC2;
  late AnimationController aC3;
  late Animation<double> a;
  late Animation<double> b;
  late Animation<double> c;

  @override
  void initState() {
    super.initState();
    aC1 = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    aC2 = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    aC3 = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    a = Tween<double>(begin: 0.0, end: 1.0).animate(aC1);
    b = Tween<double>(begin: 0.0, end: 1.0).animate(aC2);
    c = Tween<double>(begin: 0.0, end: 1.0).animate(aC3);
    firstValue();
    secondValue();
    thirdValue();
    if (mounted) {
      aC1.forward();
    }
  }

  @override
  void dispose() {
    aC1.dispose();
    aC2.dispose();
    aC3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: aC1,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: aC3,
          builder: (context, _) {
            return Container(
              constraints: const BoxConstraints(
                minHeight: 118,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.grey.shade200,
                    Colors.grey.shade400,
                    Colors.grey.shade200,
                  ],
                  stops: [
                    c.value,
                    b.value,
                    a.value,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  firstValue() {
    c.addListener(
      () {
        if (c.isCompleted) {
          aC3.reverse();
        }
        if (c.status.name == 'reverse') {
          if (c.value > 0.8) {
            return;
          } else {
            aC2.reverse();
          }
        }
      },
    );
  }

  secondValue() {
    a.addListener(
      () {
        if (a.status.name == 'forward') {
          if (a.value < 0.2) {
            return;
          } else {
            aC2.forward();
          }
        }
        if (a.isDismissed) {
          aC1.forward();
        }
      },
    );
  }

  thirdValue() {
    b.addListener(
      () {
        if (b.status.name == 'forward') {
          if (b.value < 0.2) {
            return;
          } else {
            aC3.forward();
          }
        }
        if (b.status.name == 'reverse') {
          if (b.value > 0.8) {
            return;
          } else {
            aC1.reverse();
          }
        }
      },
    );
  }
}

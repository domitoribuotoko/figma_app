import 'package:figma_app/base/app_constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_classes.dart';
import 'app_methods.dart';

Widget circularChart(double maxValue, double expenditure,String innerRadius) {
  List<Value> data = [
    Value(
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
      RadialBarSeries<Value, String>(
        radius: '100%',
        strokeColor: Colors.blue,
        animationDuration: 0,
        dataSource: data,
        xValueMapper: (Value data, _) => data.x,
        yValueMapper: (Value data, _) => data.calories,
        maximumValue: data[0].calories.toDouble() > maxValue ? data[0].calories.toDouble() : maxValue,
        cornerStyle: setCurves(),
        innerRadius: innerRadius,
        trackColor: colors.lightGreyColor,
      ),
    ],
  );
}

final List<SalesData> chartData = <SalesData>[
  SalesData(0.1, 11, DateTime.now()),
  SalesData(0.1, 11, DateTime.now().subtract(const Duration(days: 1))),
  SalesData(0.1, 10.5, DateTime.now().subtract(const Duration(days: 2))),
  SalesData(0.1, 11.6, DateTime.now().subtract(const Duration(days: 3))),
  SalesData(0.1, 11, DateTime.now().subtract(const Duration(days: 4))),
  SalesData(0.1, 11, DateTime.now().subtract(const Duration(days: 5))),
  SalesData(0.1, 9, DateTime.now().subtract(const Duration(days: 6)))
];

double maxValue() {
  final List<double> values = [];
  for (var element in chartData) {
    values.add(element.b);
  }
  values.sort();
  return values.last;
}

Widget cartesianChart(double size) {
  return SfCartesianChart(
    margin: const EdgeInsets.all(0),
    series: getDefaultData(size),
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
    ),
    primaryXAxis: DateTimeAxis(
      isVisible: false,
      // visibleMaximum: DateTime.now(),
      interval: 1,
      intervalType: DateTimeIntervalType.days,
      // visibleMinimum: DateTime.now().subtract(const Duration(days: 6)),
      axisLine: const AxisLine(
        width: 0,
      ),
    ),
    primaryYAxis: NumericAxis(
      // anchorRangeToVisiblePoints: false,
      visibleMaximum: maxValue(),
      interval: 1,
      isVisible: false,
      axisLine: const AxisLine(
        width: 0,
      ),
    ),
    plotAreaBorderWidth: 0,
    // enableAxisAnimation: true,
    onMarkerRender: (MarkerRenderArgs args) {
      if (!(args.pointIndex == 2)) {
        args.markerHeight = 0.0;
        args.markerWidth = 0.0;
      }
    },
  );
}

class SalesData {
  SalesData(
    this.a,
    this.b,
    this.c,
  );
  double a;
  double b;
  DateTime c;
}

List<SplineAreaSeries<SalesData, dynamic>> getDefaultData(double size) {
  return <SplineAreaSeries<SalesData, dynamic>>[
    SplineAreaSeries<SalesData, dynamic>(
      dataSource: chartData,
      xValueMapper: (SalesData sales, _) => sales.c,
      yValueMapper: (SalesData sales, _) => sales.b,
      yAxisName: 'Date',
      splineType: SplineType.cardinal,
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
        borderWidth: 0.9,
      ),
    ),
    // StackedArea100Series<SalesData, dynamic>(
    //   dataSource: chartData,
    //   xValueMapper: (SalesData sales, _) => sales.c,
    //   yValueMapper: (SalesData sales, _) => 0.1,
    //   yAxisName: 'Date',
    //   // gradient: LinearGradient(
    //   //   colors: [colors.cartesianGradient, colors.cartesianGradient.withOpacity(0.1)],
    //   //   begin: Alignment.topCenter,
    //   //   end: Alignment.bottomCenter,
    //   // ),
    //   color: Colors.transparent,
    //   animationDuration: 0,
    //   borderDrawMode: BorderDrawMode.top,
    //   // markerSettings: const MarkerSettings(
    //   //   isVisible: true,
    //   //   borderColor: Color(0xff88a2ff),
    //   //   color: Colors.white,
    //   //   height: 3,
    //   //   width: 3,
    //   //   borderWidth: 0.9,
    //   // ),
    // ),
  ];
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
      minimumSize: Size(method.hSizeCalc(165), 41),
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

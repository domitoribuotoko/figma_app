import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_config.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

ValueNotifier<bool> fatSwitcher = ValueNotifier(true);
ValueNotifier<bool> caloriesSwitcher = ValueNotifier(true);
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _CalculatePageState extends State<CalculatePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
  );
  final ValueNotifier<int> _tabIndex = ValueNotifier<int>(0);
  final GlobalKey<FormState> _formCaloriesKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formFatKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).hideCurrentSnackBar();
          return Future.value(true);
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            toolbarHeight: 92,
            backgroundColor: colors.mainBackgrounColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.of(scaffoldKey.currentContext!).pop();
                    ScaffoldMessenger.of(scaffoldKey.currentContext!).hideCurrentSnackBar();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    // color: Colors.blue,
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
                  'Calculate',
                  style: tS.main32TS,
                ),
              ],
            ),
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(41),
              child: ValueListenableBuilder(
                valueListenable: _tabIndex,
                builder: (context, value, widget) {
                  return customTabBar('Calories','Fat',_tabController, _tabIndex);
                },
              ),
            ),
          ),
          backgroundColor: colors.mainBackgrounColor,
          body: Padding(
            padding: EdgeInsets.only(
              top: method.vSizeCalc(30),
            ),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Column(
                  children: [
                    switcherDefault('calories'),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: caloriesAdd(
                              _formCaloriesKey,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    switcherDefault('fat'),
                    Expanded(
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverToBoxAdapter(
                            child: fatAdd(
                              _formFatKey,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget caloriesAdd(GlobalKey<FormState> formKey, BuildContext context) {
  late Map<String, int> addedMap;
  late String name;
  late int calories;
  return ValueListenableBuilder(
    valueListenable: caloriesSwitcher,
    builder: (context, value, _) {
      return Form(
        key: formKey,
        child: Column(
          children: [
            formField(
              fieldName: caloriesSwitcher.value ? 'Food' : 'Expenditure',
              hintText: caloriesSwitcher.value ? 'Product name' : 'Expenditure Name',
              onSaved: (newValue) {
                name = newValue!.trim();
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              type: '',
            ),
            formField(
              fieldName: 'Number of calories',
              onSaved: (newValue) {
                calories = int.parse(newValue!.trim());
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              type: 'kcal',
            ),
            addButton(
              formKey,
              context,
              () {
                if (caloriesSwitcher.value) {
                  addedMap = {name: calories};
                  var data = config.box.get(method.dateToKey())!..food.add(addedMap);
                  data.save();
                  config.daylyData.value = DateTime.now().toString();
                } else {
                  addedMap = {name: calories};
                  var data = config.box.get(method.dateToKey())!..expenditure.add(addedMap);
                  data.save();
                  config.daylyData.value = DateTime.now().toString();
                }
                return 'saved';
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget fatAdd(GlobalKey<FormState> formKey, BuildContext context) {
  Map<String, double> measures = {};
  List<String> formNames = [
    'Height',
    'Weight',
    'Neck girth',
    'Waist circumference',
  ];
  return Column(
    children: [
      Form(
        key: formKey,
        child: Column(
          children: List.generate(
            formNames.length,
            (index) => formField(
              fieldName: formNames[index],
              onSaved: (newValue) {
                measures.addAll({formNames[index]: double.parse(newValue!)});
                // print(newValue);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              type: index == 1 ? 'kg' : 'cm',
            ),
          )
            ..add(
              ValueListenableBuilder(
                valueListenable: fatSwitcher,
                builder: (context, value, _) {
                  return Visibility(
                    visible: !fatSwitcher.value,
                    child: formField(
                      fieldName: 'Hip girth',
                      onSaved: (newValue) {
                        measures.addAll({'Hip girth': double.parse(newValue!)});
                        // print(newValue);
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  );
                },
              ),
            )
            ..add(
              addButton(
                formKey,
                context,
                () {
                  List calculates = method.calculateFats(
                    fatSwitcher.value ? 'male' : 'female',
                    measures['Height']!,
                    measures['Weight']!,
                    measures['Neck girth']!,
                    measures['Waist circumference']!,
                    measures['Hip girth'],
                  );
                  if (calculates[0] < 0 || calculates[0] > 100 || calculates[0].toString() == 'NaN') {
                    return 'invalid data';
                  } else {
                    Fat calculatedFat = Fat(
                      calculates[0],
                      calculates[1],
                      calculates[2],
                      calculates[3],
                    );
                    var data = config.box.get(method.dateToKey())!..fat = calculatedFat;
                    data.save();
                    config.daylyData.value = DateTime.now().toString();
                    return 'saved';
                  }
                },
              ),
            ),
        ),
      ),
    ],
  );
}

Widget switcherCustom() {
  return Padding(
    padding: EdgeInsets.only(bottom: method.vSizeCalc(30)),
    child: ValueListenableBuilder(
      valueListenable: fatSwitcher,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              2,
              (index) => GestureDetector(
                onTap: () {
                  index == 0 ? fatSwitcher.value = true : fatSwitcher.value = false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: fatSwitcher.value
                        ? index == 0
                            ? Colors.blue
                            : Colors.grey
                        : index == 1
                            ? Colors.pink
                            : Colors.grey,
                  ),
                  height: 41,
                  width: metrix.screenWidth / 3,
                  child: Directionality(
                    textDirection: index == 0 ? TextDirection.rtl : TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            index == 0 ? 'Male' : 'Female',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(
                          index == 1 ? Icons.female : Icons.male,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget switcherDefault(String page) {
  String setIcon(int index) {
    if (page == 'fat') {
      return fatSwitcher.value
          ? index == 0
              ? ipath.checkMark
              : ipath.uncheckMark
          : index == 1
              ? ipath.checkMark
              : ipath.uncheckMark;
    } else {
      return caloriesSwitcher.value
          ? index == 0
              ? ipath.checkMark
              : ipath.uncheckMark
          : index == 1
              ? ipath.checkMark
              : ipath.uncheckMark;
    }
  }

  return Padding(
    padding: EdgeInsets.only(
      bottom: method.vSizeCalc(30),
      left: method.hSizeCalc(40),
      right: method.hSizeCalc(40),
    ),
    child: ValueListenableBuilder(
      valueListenable: page == 'fat' ? fatSwitcher : caloriesSwitcher,
      builder: (context, value, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
            2,
            (index) => GestureDetector(
              onTap: () {
                if (page == 'fat') {
                  index == 0 ? fatSwitcher.value = true : fatSwitcher.value = false;
                } else {
                  index == 0 ? caloriesSwitcher.value = true : caloriesSwitcher.value = false;
                }
              },
              child: Container(
                color: colors.mainBackgrounColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      setIcon(index),
                    ),
                    SizedBox(
                      width: method.hSizeCalc(20),
                    ),
                    FittedBox(
                      child: Text(
                        index == 0
                            ? page == 'fat'
                                ? 'Male'
                                : 'Food'
                            : page == 'fat'
                                ? 'Female'
                                : 'Expenditure',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget addButton(GlobalKey<FormState> formKey, BuildContext context, Function() saveTostorage) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 20,
    ),
    child: TextButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          String result = saveTostorage();
          if (result == 'invalid data') {
            showSnackAlert('Invalid data entered');
            return;
          } else {
            showSnackAlert('Added');
            formKey.currentState!.reset();
          }
        } else {
          showSnackAlert('Fill in the fields');
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: colors.redColor,
        minimumSize: const Size(140, 51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Add',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    ),
  );
}

showSnackAlert(
  String text,
) {
  ScaffoldMessenger.of(scaffoldKey.currentContext!)
      .showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.mainColor,
          content: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          duration: const Duration(milliseconds: 800),
        ),
      )
      .closed
      .then(
    (value) {
      ScaffoldMessenger.of(scaffoldKey.currentContext!).clearSnackBars();
    },
  );
}

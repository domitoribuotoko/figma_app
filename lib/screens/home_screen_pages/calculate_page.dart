import 'package:figma_app/base/app_constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/app_methods.dart';
import '../../base/app_widgets.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

ValueNotifier<bool> isSwitched = ValueNotifier(false);

class _CalculatePageState extends State<CalculatePage> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 92,
          backgroundColor: colors.mainBackgrounColor,
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tabButton(
                      ontap: () {
                        _tabController.animateTo(
                          0,
                        );
                        _tabIndex.value = 0;
                      },
                      buttonColor: _tabIndex.value == 0 ? colors.mainColor : Colors.white,
                      text: 'Calories',
                      textColor: _tabIndex.value != 0 ? colors.mainColor : Colors.white,
                    ),
                    SizedBox(
                      width: method.hSizeCalc(20),
                    ),
                    tabButton(
                      ontap: () {
                        _tabController.animateTo(
                          1,
                        );
                        _tabIndex.value = 1;
                      },
                      buttonColor: _tabIndex.value == 1 ? colors.mainColor : Colors.white,
                      text: 'Fat',
                      textColor: _tabIndex.value != 1 ? colors.mainColor : Colors.white,
                    ),
                  ],
                );
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
            // physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: caloriesAdd(
                      _formCaloriesKey,
                      context,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  switcher(),
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
    );
  }
}

Widget caloriesAdd(GlobalKey<FormState> formKey, BuildContext context) {
  return Form(
    key: formKey,
    child: Column(
      children: [
        formField(
          fieldName: 'Food',
          hintText: 'Product name',
          onSaved: (newValue) {},
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
        ),
        formField(
          fieldName: 'Number of calories',
          onSaved: (newValue) {},
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        addButton(
          formKey,
          context,
        ),
      ],
    ),
  );
}

Widget fatAdd(GlobalKey<FormState> formKey, BuildContext context) {
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
                print(newValue);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          )
            ..add(
              ValueListenableBuilder(
                valueListenable: isSwitched,
                builder: (context, value, _) {
                  return Visibility(
                    visible: !isSwitched.value,
                    child: formField(
                      fieldName: 'Hip girth',
                      onSaved: (newValue) {
                        print(newValue);
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
              ),
            ),
        ),
      ),
    ],
  );
}

Widget switcher() {
  return Padding(
    padding: EdgeInsets.only(bottom: method.vSizeCalc(30)),
    child: ValueListenableBuilder(
      valueListenable: isSwitched,
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
                  index == 0 ? isSwitched.value = true : isSwitched.value = false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSwitched.value
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
                            index == 1 ? 'Female' : 'Male',
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

Widget addButton(GlobalKey<FormState> formKey, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 20,
    ),
    child: TextButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          formKey.currentState!.reset();
        } else {
          showSnackAlert(context);
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

showSnackAlert(BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          backgroundColor: colors.mainColor,
          content: const Text(
            'Fill in the fields',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          duration: const Duration(milliseconds: 1000),
        ),
      )
      .closed
      .then(
    (value) {
      ScaffoldMessenger.of(context).clearSnackBars();
    },
  );
}

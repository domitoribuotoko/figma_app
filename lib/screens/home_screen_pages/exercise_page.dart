import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:figma_app/base/exercise_base.dart';
import 'package:figma_app/screens/home_screen_pages/exercise_pages/exercise_details.dart';
import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 92,
        title: Text(
          'Exercise',
          style: tS.main32TS,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: method.hSizeCalc(20),
        ),
        child: ListView.builder(
          cacheExtent: 20,
          itemCount: exercises.modelContent.length,
          itemBuilder: (context, index) {
            var item = exercises.modelContent[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ExerciseDetails(
                        details: item,
                      );
                    },
                  ),
                );
              },
              child: getExerciseContainer(
                item.name,
                item.picUrl,
                item.desc,
              ),
            );
          },
        ),
      ),
    );
  }

  getExerciseContainer(String name, String picUrl, String desc) {
    return Container(
      padding: EdgeInsets.all(
        method.hSizeCalc(15),
      ),
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: tS.black20TS,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            constraints: const BoxConstraints(
              maxHeight: 300,
              minHeight: 300,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Center(
                child: FutureBuilder(
                  future: method.validateImage(picUrl),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return Image.network(
                        picUrl,
                      );
                    }
                    if (snapshot.data == false) {
                      return Center(
                        child: Image.asset(ppath.exHolder),
                      );
                    } else {
                      return const PlaceHolderSkeletonWidget();
                    }
                  },
                ),
              ),
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              fontSize: 16,
              color: colors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}

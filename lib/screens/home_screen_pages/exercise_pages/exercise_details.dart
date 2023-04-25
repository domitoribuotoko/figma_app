import 'package:figma_app/base/app_classes.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../base/app_methods.dart';

class ExerciseDetails extends StatefulWidget {
  final ModelSport details;
  const ExerciseDetails({
    super.key,
    required this.details,
  });

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      appBar: AppBar(
        toolbarHeight: 92,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
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
            Flexible(
              child: Text(
                widget.details.name,
                // maxLines: 4,
                style: TextStyle(
                  color: colors.mainColor,
                  fontSize: 24,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: method.hSizeCalc(20),
        ),
        child: SingleChildScrollView(
          child: getExerciseContainer(
            widget.details.name,
            widget.details.picUrl,
            widget.details.desc,
          ),
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
          ...List<Widget>.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '${index + 1}. Procedure',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.greyColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

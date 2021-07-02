import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/gradientMask.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';

class SelectExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final Function onTap;
  final bool isSelected;
  SelectExerciseTile(
      {required this.exercise, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: GestureDetector(
        child: Card(
          color: Colors.black.withAlpha(70),
          margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isSelected
                    ? exerciseIsSelectedCircle()
                    : exercise.equipmentTypeIconLocation == ''
                        ? Container()
                        : Container(
                            height: Constants.exerciseTypeIconWidth,
                            width: Constants.exerciseTypeIconWidth,
                            child: ImageIcon(
                              AssetImage(exercise.equipmentTypeIconLocation),
                              color: Constants.primaryColor.withAlpha(230),
                            ),
                          ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 5, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exercise.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Constants.textColor,
                                  fontSize: Constants.selectExerciseFontSize)),
                          exercise.subtitle != ''
                              ? Text(exercise.subtitle,
                                  style: TextStyle(color: Constants.hintColor))
                              : Container(),
                        ]),
                  ),
                ),
                Container(
                  width: Constants.selectExerciseImageWidth,
                  height: Constants.selectExerciseImageHeight,
                  child: exercise.image,
                ),
              ],
            ),
          ),
        ),
        onTap: () => onTap(exercise),
      ),
    );
  }

  Widget exerciseIsSelectedCircle() {
    return GradientMask(
      child: CircleAvatar(
          child: isSelected
              ? Icon(Icons.check, color: Constants.darkIconColor)
              : null,
          radius: Constants.exerciseTypeIconWidth / 2,
          backgroundColor: isSelected ? Colors.white : Colors.grey),
    );
  }
}

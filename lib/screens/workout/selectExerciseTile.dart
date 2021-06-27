import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';

class SelectExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final Function onTap;
  bool isSelected;
  SelectExerciseTile(
      {required this.exercise, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0),
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isSelected
                    ? exerciseIsSelectedCircle()
                    : Container(
                        padding: EdgeInsets.all(4.0),
                        height: 35,
                        width: 35,
                        child: Opacity(
                            opacity: Constants.equipmentTypeIconOpacity,
                            child: exercise.equipmentTypeIcon),
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

  CircleAvatar exerciseIsSelectedCircle() {
    return CircleAvatar(
        child: isSelected ? Icon(Icons.check) : null,
        radius: Constants.exerciseTypeIconWidth,
        backgroundColor: isSelected ? Constants.accentColor : Colors.grey);
  }
}

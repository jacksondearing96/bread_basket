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
                CircleAvatar(
                    child: isSelected ? Icon(Icons.check) : null,
                    radius: 25.0,
                    backgroundColor:
                        isSelected ? Constants.accentColor : Colors.grey),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(exercise.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18.0)),
                      Text('subtitle goes here',
                      style: TextStyle(color: Constants.hintColor)),
                    ]),
                  ),
                ),
                Container(
                  height: 90,
                  width: 135,
                  child: Image.asset('exercise_images/${exercise.name}.png'),
                ),
              ],
            ),
          ),
        ),
        onTap: () => onTap(exercise),
      ),
    );
  }
}

import 'package:bread_basket/analytics/TotalWeightVolumeLifted.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/screens/workout/exerciseSummary.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class WorkoutSummary {
  PerformedWorkout workout;
  WorkoutSummary({required this.workout});

  Widget workoutDate() {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.black.withAlpha(70),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: Constants.exerciseTypeIconWidth,
            width: Constants.exerciseTypeIconWidth,
            child: Icon(Icons.calendar_today, color: Constants.primaryColor),
          ),
          SizedBox(width: 20),
          Expanded(
              child: Column(children: [
            Text(Constants.shorterDateFormatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                        workout.dateInMilliseconds)
                    .toLocal())),
          ])),
        ],
      ),
    );
  }

  Widget workoutName() {
    return Text(workout.name, style: TextStyle(color: Constants.textColor));
  }

  Widget exerciseList() {
    return Container(
      width: 250,
      height: 500,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: workout.Exercises.length,
          itemBuilder: (context, index) {
            return ExerciseSummary(exercise: workout.Exercises[index]);
          }),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(children: [
        Icon(Icons.check_circle, color: Constants.secondaryColor, size: 60),
        SizedBox(height: 8),
        workoutName(),
        SizedBox(height: 15),
        workoutDate(),
        SizedBox(height: 15),
        TotalWeightVolumeLifted(kgs: workout.totalVolume().round()),
        SizedBox(height: 15),
        exerciseList(),
      ]),
    );
  }

  void show(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: content(),
        backgroundColor: Constants.backgroundColor,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}

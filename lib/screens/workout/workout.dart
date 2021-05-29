import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = 'Workout';

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        title: Text(workoutName),
        actions: [
          TextButton(
            child: const Text('Finish'),
            onPressed: () {

            },
            style: TextButton.styleFrom(
              primary: Constants.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

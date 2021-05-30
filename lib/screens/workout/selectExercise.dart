import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/exerciseList.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class SelectExercise extends StatefulWidget {
  final List<Exercise> exercises;
  SelectExercise({required this.exercises});

  @override
  _SelectExerciseState createState() => _SelectExerciseState();
}

class _SelectExerciseState extends State<SelectExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        title: Text('Select exercise'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              primary: Constants.textColor,
            ),
          ),
        ],
      ),
      body: ExerciseList(exercises: widget.exercises),
    );
  }
}

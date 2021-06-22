import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/selectExerciseList.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class SelectExercise extends StatefulWidget {
  final List<Exercise> exercises;
  SelectExercise({required this.exercises});

  @override
  _SelectExerciseState createState() => _SelectExerciseState();
}

class _SelectExerciseState extends State<SelectExercise> {
  List<Exercise> selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        title: Text('Select exercises'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, 'EXERCISE SELECTED'),
            style: TextButton.styleFrom(
              primary: Constants.textColor,
            ),
          ),
        ],
      ),
      body: SelectExerciseList(exercises: widget.exercises, selectedExercises: selectedExercises),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, selectedExercises),
        tooltip: 'New exercise',
        child: Icon(Icons.check),
      ),
    );
  }
}

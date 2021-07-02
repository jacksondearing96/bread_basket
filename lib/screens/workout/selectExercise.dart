import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/selectExerciseList.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customFloatingActionButton.dart';
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
      body: SafeArea(
          child: SelectExerciseList(
              exercises: widget.exercises,
              selectedExercises: selectedExercises)),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Navigator.pop(context, selectedExercises),
        tooltip: 'New exercise',
        iconData: Icons.check,
      ),
    );
  }
}

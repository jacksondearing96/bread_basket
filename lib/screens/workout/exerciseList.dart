import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/exerciseTile.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  ExerciseList({required this.exercises});

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          return ExerciseTile(exercise: widget.exercises[index]);
        });
  }
}

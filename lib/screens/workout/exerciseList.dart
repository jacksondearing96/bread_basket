import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/exerciseTile.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  List<Exercise> selectedExercises;
  ExerciseList({required this.exercises, required this.selectedExercises});

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    void onExerciseTileTap(Exercise exercise) {
      if (!widget.selectedExercises.contains(exercise)) {
        setState(() => widget.selectedExercises.add(exercise));
      } else {
        setState(() =>
            widget.selectedExercises.removeWhere((val) => val.equals(exercise)));
      }
    }

    return ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          return Container(
            child: ExerciseTile(
              exercise: widget.exercises[index],
              onTap: onExerciseTileTap,
              isSelected: widget.selectedExercises.contains(widget.exercises[index]),
            ),
          );
        });
  }
}

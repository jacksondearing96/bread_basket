import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/screens/workout/selectExerciseTile.dart';
import 'package:flutter/material.dart';

class SelectExerciseList extends StatefulWidget {
  final List<Exercise> exercises;
  List<Exercise> selectedExercises;
  SelectExerciseList({required this.exercises, required this.selectedExercises});

  @override
  _SelectExerciseListState createState() => _SelectExerciseListState();
}

class _SelectExerciseListState extends State<SelectExerciseList> {
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
            child: SelectExerciseTile(
              exercise: widget.exercises[index],
              onTap: onExerciseTileTap,
              isSelected: widget.selectedExercises.contains(widget.exercises[index]),
            ),
          );
        });
  }
}

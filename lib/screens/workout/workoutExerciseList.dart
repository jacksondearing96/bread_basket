import 'dart:async';

import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/screens/workout/workoutExerciseTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseList extends StatefulWidget {
  WorkoutExerciseList();

  @override
  _WorkoutExerciseListState createState() => _WorkoutExerciseListState();
}

class _WorkoutExerciseListState extends State<WorkoutExerciseList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PerformedExerciseListProvider>(
      builder: (context, performedExercisesProvider, child) => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: performedExercisesProvider.exercises.length,
          itemBuilder: (context, index) {
            return Container(
              child: ChangeNotifierProvider.value(
                value: performedExercisesProvider.exercises[index],
                child: WorkoutExerciseTile(key: UniqueKey(),
                    exerciseIndex: index),
              ),
            );
          }),
    );
  }
}

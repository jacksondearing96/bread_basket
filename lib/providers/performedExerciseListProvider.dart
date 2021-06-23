import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:flutter/material.dart';

class PerformedExerciseListProvider extends ChangeNotifier {
  List<PerformedExerciseProvider> _exercises = [];

  List<PerformedExerciseProvider> get exercises => _exercises;

  void addExercise(PerformedExercise exercise) {
    print('Adding exercise to provider');
    exercise.log();
    _exercises.add(PerformedExerciseProvider(exercise_: exercise));
    notifyListeners();
  }
}

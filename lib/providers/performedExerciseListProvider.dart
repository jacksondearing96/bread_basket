import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:flutter/material.dart';

class PerformedExerciseListProvider extends ChangeNotifier {
  List<PerformedExerciseProvider> _exercises = [];

  List<PerformedExerciseProvider> get exercises => _exercises;

  void addExercise(PerformedExercise exercise) {
    _exercises.add(PerformedExerciseProvider(performedExercise: exercise));
    notifyListeners();
  }

  void removeExercise(int index) {
    _exercises.removeAt(index);
    notifyListeners();
  }
}

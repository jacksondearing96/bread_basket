import 'package:bread_basket/models/performedExercise.dart';
import 'package:flutter/material.dart';

class PerformedExercisesProvider extends ChangeNotifier {
  List<PerformedExercise> _exercises = [];

  List<PerformedExercise> get exercises => _exercises;

  void addExercise(PerformedExercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }
}

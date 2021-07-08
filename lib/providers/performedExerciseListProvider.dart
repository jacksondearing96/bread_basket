import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:flutter/material.dart';

class ExerciseListProvider extends ChangeNotifier {
  List<ExerciseProvider> _exercises = [];

  List<ExerciseProvider> get exercises => _exercises;

  void addExercise(Exercise exercise) {
    _exercises.add(ExerciseProvider(exerciseToProvide: exercise));
    notifyListeners();
  }

  void removeExercise(int index) {
    _exercises.removeAt(index);
    notifyListeners();
  }
}

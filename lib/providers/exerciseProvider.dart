import 'package:bread_basket/models/cardioSession.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:flutter/material.dart';

class ExerciseProvider extends ChangeNotifier {
  late Exercise _exercise;

  ExerciseProvider({required exerciseToProvide}) {
    _exercise = exerciseToProvide;
  }

  Exercise get exercise => _exercise;

  void updateExercise(Exercise newExercise) {
    _exercise = newExercise;
    notifyListeners();
  }

  void updateSet(int index, PerformedSet performedSet) {
    _exercise.sets[index] = performedSet;
    notifyListeners();
  }

  void updateCardioSession(int index, CardioSession cardioSession) {
    _exercise.cardioSessions[index] = cardioSession;
    notifyListeners();
  }

  void removeSet(int index) {
    _exercise.sets.removeAt(index);
    notifyListeners();
  }

  void addSet() {
    _exercise.sets.add(PerformedSet());
    notifyListeners();
  }

  PerformedSet? bestSet() {
    PerformedSet? best;
    double bestWeight = 0;
    for (var performedSet in _exercise.sets) {
      if (performedSet.weight > bestWeight) {
        best = performedSet;
        bestWeight = performedSet.weight;
      }
    }
    return best;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:flutter/material.dart';

class PerformedExerciseProvider extends ChangeNotifier {
  PerformedExercise performedExercise;

  PerformedExerciseProvider({required this.performedExercise});

  PerformedExercise get exercise => performedExercise;

  void updateExercise(PerformedExercise newPerformedExercise) {
    performedExercise = newPerformedExercise;
    notifyListeners();
  }

  void updateSet(int index, PerformedSet performedSet) {
    performedExercise.sets[index] = performedSet;
    notifyListeners();
  }

  void removeSet(int index) {
    performedExercise.sets.removeAt(index);
    notifyListeners();
  }

  void addSet() {
    performedExercise.sets.add(PerformedSet());
    notifyListeners();
  }

  PerformedSet? bestSet() {
    PerformedSet? best;
    double bestWeight = 0;
    for (var performedSet in performedExercise.sets) {
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

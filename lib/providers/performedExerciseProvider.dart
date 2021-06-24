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
    print('Updating provider' 's set at index: $index');
    performedSet.log();
    performedExercise.sets[index] = performedSet;
    notifyListeners();
  }

  void removeSet(int index) {
    print('Removing provider' 's set at index: $index');
    performedExercise.sets.removeAt(index);
    notifyListeners();
  }

  void addSet() {
    print('Adding a set to the provider');
    performedExercise.sets.add(PerformedSet());
    notifyListeners();
  }

  @override
  void dispose() {
    print('DISPOSING OF performedExerciseProvider !!!');
    super.dispose();
  }
}

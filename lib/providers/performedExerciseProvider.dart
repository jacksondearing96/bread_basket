import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:flutter/material.dart';

class PerformedExerciseProvider extends ChangeNotifier {
  PerformedExercise exercise_;

  PerformedExerciseProvider({required this.exercise_});

  PerformedExercise get exercise => exercise_;

  void updateExercise(PerformedExercise performedExercise) {
    exercise_ = performedExercise;
    notifyListeners();
  }

  void updateSet(int index, PerformedSet performedSet) {
    print('Updating provider' 's set at index: $index');
    performedSet.log();
    exercise_.sets[index] = performedSet;
    notifyListeners();
  }

  void removeSet(int index) {
    print('Removing provider' 's set at index: $index');
    exercise_.sets.removeAt(index);
    notifyListeners();
  }

  void addSet() {
    print('Adding a set to the provider');
    exercise_.sets.add(PerformedSet());
    notifyListeners();
  }

  @override
  void dispose() {
    print('DISPOSING OF performedExerciseProvider !!!');
    super.dispose();
  }
}

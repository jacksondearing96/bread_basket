import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:flutter/material.dart';

class PerformedExercise {
  final Exercise exercise;
  final String id = DateTime.now().millisecondsSinceEpoch.toString();
  List<PerformedSet> sets = [PerformedSet()];

  PerformedExercise({required this.exercise});

  void log() {
    print("PERFORMED EXERCISE >> Exercise ID: " +
        this.exercise.id +
        ", name: " +
        this.exercise.name +
        ", sets: " +
        this.sets.length.toString());
  }
}

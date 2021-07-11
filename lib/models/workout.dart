import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PerformedWorkout {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String id = UniqueKey().toString();
  PerformedWorkout();

  List<Exercise> exercises = [];
  String name = Constants.newWorkoutName;

  bool equals(PerformedWorkout other) {
    if (exercises.length != other.exercises.length) return false;
    for (int i = 0; i < exercises.length; ++i) {
      if (!exercises[i].equals(other.exercises[i])) return false;
    }
    return timestamp == other.timestamp && id == other.id && name == other.name;
  }

  static PerformedWorkout fromJson(Map<String, Object?> json) {
    PerformedWorkout workout = PerformedWorkout();
    workout.name = json['name']! as String;
    workout.timestamp = json['timestamp']! as int;
    workout.id = json['id'] as String;

    Map<dynamic, dynamic> exercisesJson =
        json['exercises']! as Map<dynamic, dynamic>;
    for (var exerciseId in exercisesJson.keys) {
      workout.exercises.add(Exercise.fromJson(
          exercisesJson[exerciseId]! as Map<String, Object?>));
    }
    return workout;
  }

  clearEmptySetsAndExercises() {
    exercises.forEach(
        (exercise) => exercise.sets.removeWhere((set) => set.reps == 0));
    exercises.removeWhere((exercise) => exercise.sets.isEmpty);
  }

  Map<String, Object?> toJson() {
    clearEmptySetsAndExercises();
    Map<String, dynamic> workoutJson = {
      'name': name,
      'id': id,
      'timestamp': timestamp,
      'exercises': {},
    };
    for (var exercise in exercises) {
      if (exercise.sets.isNotEmpty) {
        workoutJson['exercises'][exercise.id] = exercise.toJson();
      }
    }
    return workoutJson;
  }

  double totalVolume() {
    double totalVolume = 0;
    for (Exercise exercise in exercises) {
      totalVolume += exercise.totalVolume();
    }
    return totalVolume;
  }

  void log({String? message}) {
    print('');
    print(message);
    print(
        'WORKOUT[$id]: name: $name, date: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}');
    for (var exercise in exercises) {
      exercise.log();
    }
  }
}

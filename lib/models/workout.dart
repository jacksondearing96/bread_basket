import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';

class PerformedWorkout {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  int dateInMilliseconds = DateTime.now().millisecondsSinceEpoch;
  PerformedWorkout();

  List<Exercise> Exercises = [];
  String name = "New Workout";

  static PerformedWorkout fromJson(Map<String, Object?> json, String id) {
    PerformedWorkout workout = PerformedWorkout();
    workout.name = json['name']! as String;
    workout.dateInMilliseconds = json['dateInMilliseconds']! as int;
    workout.id = id;

    Map<String, Object?> exercisesJson =
        json['exercises']! as Map<String, Object?>;
    for (var exerciseId in exercisesJson.keys) {
      workout.Exercises.add(Exercise.fromJson(
          exercisesJson[exerciseId]! as Map<String, Object?>, exerciseId));
    }
    return workout;
  }

  clearEmptySetsAndExercises() {
    Exercises.forEach(
        (exercise) => exercise.sets.removeWhere((set) => set.reps == 0));
    Exercises.removeWhere((exercise) => exercise.sets.isEmpty);
  }

  Map<String, Object?> toJson() {
    clearEmptySetsAndExercises();
    Map<String, dynamic> workoutData = {
      'name': name,
      'dateInMilliseconds': dateInMilliseconds,
      'exercises': {},
    };
    for (var exercise in Exercises) {
      if (exercise.sets.isNotEmpty) {
        workoutData['exercises'][exercise.id] = exercise.toJson();
      }
    }
    return {id: workoutData};
  }

  double totalVolume() {
    double totalVolume = 0;
    for (Exercise exercise in Exercises) {
      totalVolume += exercise.totalVolume();
    }
    return totalVolume;
  }

  void log({String? message}) {
    print('');
    print(message);
    print(
        'WORKOUT[$id]: name: $name, date: ${DateTime.fromMillisecondsSinceEpoch(dateInMilliseconds)}');
    for (var exercise in Exercises) {
      exercise.log();
    }
  }
}

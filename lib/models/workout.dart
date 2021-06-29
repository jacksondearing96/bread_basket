import 'package:bread_basket/models/performedExercise.dart';

class PerformedWorkout {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  int dateInMilliseconds = DateTime.now().millisecondsSinceEpoch;
  PerformedWorkout();

  List<PerformedExercise> performedExercises = [];
  String name = "New Workout";

  static PerformedWorkout fromJson(Map<String, Object?> json, String id) {
    print('Creating a PerformedWorkout from json, using: ');
    print(json);
    PerformedWorkout workout = PerformedWorkout();
    workout.name = json['name']! as String;
    workout.dateInMilliseconds = json['dateInMilliseconds']! as int;
    workout.id = id;

    Map<String, Object?> exercisesJson =
        json['exercises']! as Map<String, Object?>;
    for (var exerciseId in exercisesJson.keys) {
      workout.performedExercises.add(PerformedExercise.fromJson(
          exercisesJson[exerciseId]! as Map<String, Object?>, exerciseId));
    }
    return workout;
  }

  Map<String, Object?> toJson() {
    // TODO: Separate this work into each class.
    Map<String, dynamic> workoutData = {
      'name': name,
      'dateInMilliseconds': dateInMilliseconds,
      'exercises': {},
    };
    for (var exercise in performedExercises) {
      Map<String, dynamic> exerciseData = {
        'exerciseId': exercise.exercise.id,
        'name': exercise.exercise.name,
        'tags': exercise.exercise.tags,
        'sets': {}
      };
      for (var set in exercise.sets) {
        // Skip empty sets.
        if (set.reps == 0) continue;

        exerciseData['sets'][set.id] = {
          'type': set.setType,
          'weight': set.weight,
          'reps': set.reps
        };
      }
      workoutData['exercises'][exercise.id] = exerciseData;
    }

    return {id: workoutData};
  }

  void log(String message) {
    print(message);
    print('WORKOUT[$id]: $name');
    for (var exercise in performedExercises) {
      print(
          'Exercise[${exercise.id}]: ${exercise.exercise.name} (id = ${exercise.exercise.id})');
      int setNumber = 0;
      for (var set in exercise.sets) {
        print(
            'Set[${set.id}]: ${setNumber++}: weight = ${set.weight}, reps = ${set.reps}');
      }
    }
  }
}

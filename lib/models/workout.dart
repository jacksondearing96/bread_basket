import 'package:bread_basket/models/performedExercise.dart';

class PerformedWorkout {
  final String id;
  PerformedWorkout({required this.id});

  List<PerformedExercise> performedExercises = [];
  String date = "date";
  String name = "New Workout";

  void log(String message) {
    print(message);
    print('WORKOUT[$id]: $name');
    print('Date: $date');
    for (var exercise in performedExercises) {
      print('Exercise[${exercise.id}]: ${exercise.exercise.name} (id = ${exercise.exercise.id})');
      int setNumber = 0;
      for (var set in exercise.sets) {
        print('Set[${set.id}]: ${setNumber++}: weight = ${set.weight}, reps = ${set.reps}');
      }
    }
  }
}
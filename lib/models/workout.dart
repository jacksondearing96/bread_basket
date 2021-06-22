import 'package:bread_basket/models/performedExercise.dart';

class PerformedWorkout {
  final String id;
  PerformedWorkout({required this.id});

  List<PerformedExercise> performedExercises = [];
  String date = "date";
  String name = "New Workout";
}

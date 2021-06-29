import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';

class PerformedExercise {
  final Exercise exercise;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  List<PerformedSet> sets = [PerformedSet()];

  PerformedExercise({required this.exercise});

  static PerformedExercise fromJson(Map<String, Object?> json, String id) {
    PerformedExercise performedExercise = PerformedExercise(
        exercise: Exercise(
            id: json['exerciseId']! as String,
            name: json['name']! as String,
            tags: json['tags']! as List<dynamic>));
    performedExercise.id = id;

    Map<String, Object?> setsJson = json['sets']! as Map<String, Object?>;
    for (var setId in setsJson.keys) {
      performedExercise.sets.add(PerformedSet.fromJson(
          setsJson[setId]! as Map<String, dynamic>, setId));
    }
    performedExercise.sets
        .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    return performedExercise;
  }

  double totalVolume() {
    double totalVolume = 0;
    for (PerformedSet performedSet in sets) {
      totalVolume += performedSet.volume();
    }
    return totalVolume;
  }

  void log() {
    print("PERFORMED EXERCISE >> Exercise ID: " +
        this.exercise.id +
        ", name: " +
        this.exercise.name +
        ", sets: " +
        this.sets.length.toString());
  }
}

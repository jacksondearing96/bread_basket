import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';

class PerformedExercise {
  final Exercise exercise;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  List<PerformedSet> sets = [PerformedSet()];

  PerformedExercise({required this.exercise});

  static PerformedExercise fromJson(Map<String, Object?> json, String id) {
    print('Creating a PerformedExercise from json, using: ');
    print(json);
    print('id: ${json['exerciseId']! as String}');
    print('name: ${json['name']! as String}');
    print('tags: ${json['tags']! as List<dynamic>}');
    PerformedExercise performedExercise = PerformedExercise(
        exercise: Exercise(
            id: json['exerciseId']! as String,
            name: json['name']! as String,
            tags: json['tags']! as List<dynamic>));
    performedExercise.id = id;
    print('progress: ');
    print(performedExercise.id);

    Map<String, Object?> setsJson = json['sets']! as Map<String, Object?>;
    print('setsJson: ${setsJson}');
    for (var setId in setsJson.keys) {
      performedExercise.sets.add(PerformedSet.fromJson(
          setsJson[setId]! as Map<String, dynamic>, setId));
    }

    return performedExercise;
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

import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise tests', () {
    late Exercise testExercise;
    const int testExerciseId = Constants.deadliftExerciseId;
    const String testName = Constants.deadliftExerciseName;
    List<String> testTags = ['chest', 'shoulders'];
    PerformedSet testSet1 = PerformedSet(weight: 10.0, reps: 7);
    PerformedSet testSet2 = PerformedSet(weight: 5.5, reps: 11);
    setUp(() {
      testExercise = Exercise(
          exerciseId: testExerciseId.toString(),
          name: testName,
          tags: testTags);

      testExercise.sets.add(testSet1);
      testExercise.sets.add(testSet2);
    });

    test('Initialisation', () {
      expect(testExercise.name, testName);
      expect(testExercise.tags, testTags);
      expect(testExercise.timestamp, TypeMatcher<int>());
      expect(testExercise.id, TypeMatcher<String>());
      expect(testExercise.exerciseId, '1');
      expect(testExercise.sets.length, 2);
      expect(testExercise.sets[0].equals(testSet1), isTrue);
      expect(testExercise.sets[1].equals(testSet2), isTrue);
      expect(testExercise.title, 'Deadlift');
      expect(testExercise.subtitle, '');
      expect(testExercise.imageLocation,
          'resources/exercise_images_transparent_background/deadlift_(barbell).png');
      expect(testExercise.equipmentTypeIconLocation,
          'resources/icons/barbell.png');
      expect(testExercise.tags, ['chest', 'shoulders', 'barbell']);
    });

    test('ToJson', () {
      Map<String, Object?> json = testExercise.toJson();
      expect(json['name'], testName);
      expect(json['exerciseId'], testExerciseId.toString());
      expect(json['id'], TypeMatcher<String>());
      expect(json['tags'], ['chest', 'shoulders', 'barbell']);
      expect(json['timestamp'], TypeMatcher<int>());
      expect(json['sets'], {
        testSet1.id: testSet1.toJson(),
        testSet2.id: testSet2.toJson(),
      });
      expect(json.keys.length, 6);
    });

    test('FromJson', () {
      Map<String, Object?> json = testExercise.toJson();
      Exercise fromJson = Exercise.fromJson(json);
      expect(fromJson.equals(testExercise), isTrue);
    });
  });
}

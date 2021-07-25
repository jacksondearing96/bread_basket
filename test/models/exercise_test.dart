import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter_test/flutter_test.dart';

import '../testUtil.dart';

void main() {
  group('Exercise tests', () {
    test('Initialisation', () {
      Exercise testExercise = TestUtil.testExercise();
      expect(testExercise.name, TestUtil.testName);
      expect(Util.listEquals(testExercise.tags, TestUtil.testTags), isFalse);
      List<dynamic> expected = List.from(TestUtil.testTags);
      expected.add('barbell');
      expect(Util.listEquals(testExercise.tags, expected), isTrue);
      expect(testExercise.timestamp, TypeMatcher<int>());
      expect(testExercise.id, TypeMatcher<String>());
      expect(testExercise.exerciseId, '1');
      expect(testExercise.sets.length, 2);
      expect(testExercise.sets[0].equals(TestUtil.testSet1()), isTrue);
      expect(testExercise.sets[1].equals(TestUtil.testSet2()), isTrue);
      expect(testExercise.title, 'Deadlift');
      expect(testExercise.subtitle, '');
      expect(testExercise.imageLocation,
          'resources/exercise_images_transparent_background/deadlift_(barbell).png');
      expect(testExercise.equipmentTypeIconLocation,
          'resources/icons/barbell.png');
      expect(testExercise.tags, ['chest', 'shoulders', 'barbell']);
    });

    test('ToJson', () {
      Exercise testExercise = TestUtil.testExercise();
      Map<String, Object?> json = testExercise.toJson();
      expect(json['name'], TestUtil.testName);
      expect(json['exerciseId'], TestUtil.testExerciseId);
      expect(json['id'], TypeMatcher<String>());
      expect(json['tags'], ['chest', 'shoulders', 'barbell']);
      expect(json['timestamp'], TypeMatcher<int>());
      expect(json['sets'], {
        TestUtil.testSet1().id: TestUtil.testSet1().toJson(),
        TestUtil.testSet2().id: TestUtil.testSet2().toJson(),
      });
      expect(json['cardioSessions'], {
        TestUtil.testCardioSession1().id:
            TestUtil.testCardioSession1().toJson(),
        TestUtil.testCardioSession2().id:
            TestUtil.testCardioSession2().toJson(),
      });
      expect(json.keys.length, 7);
    });

    test('FromJson', () {
      Exercise testExercise = TestUtil.testExercise();
      Map<String, Object?> json = testExercise.toJson();
      Exercise fromJson = Exercise.fromJson(json);
      expect(fromJson.equals(testExercise), isTrue);
    });

    test('Total volume', () {
      expect(TestUtil.testExercise().totalVolume(), 130.5);
    });

    test('Best set', () {
      Exercise testExercise = TestUtil.testExercise();
      expect(testExercise.bestSet().weight, 10.0);

      testExercise.sets.add(PerformedSet(weight: 15, reps: 1));
      expect(testExercise.bestSet().weight, 15);
    });

    test('Equals', () {
      Exercise testExercise = TestUtil.testExercise();
      Exercise exercise2 = Exercise(
          exerciseId: testExercise.exerciseId,
          name: testExercise.name,
          tags: List.from(testExercise.tags));

      expect(testExercise.equals(exercise2), isFalse);

      exercise2.id = testExercise.id;
      exercise2.sets = testExercise.sets.map(PerformedSet.from).toList();
      exercise2.timestamp = testExercise.timestamp;

      expect(testExercise.equals(exercise2), isTrue);

      testExercise.sets[0].weight = 99;
      expect(testExercise.equals(exercise2), isFalse);
    });
  });
}

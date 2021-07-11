import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workout tests', () {
    late PerformedWorkout testWorkout;

    const int testTimestamp = 12345;
    const String testId = 'testId';

    late Exercise testExercise;
    const int testExerciseId = Constants.deadliftExerciseId;
    const String testName = Constants.deadliftExerciseName;
    List<String> testTags = ['chest', 'shoulders'];
    PerformedSet testSet1 = PerformedSet(weight: 10.0, reps: 7);
    PerformedSet testSet2 = PerformedSet(weight: 5.5, reps: 11);

    setUp(() {
      testWorkout = PerformedWorkout();
      testWorkout.timestamp = testTimestamp;
      testWorkout.id = testId;

      testExercise = Exercise(
          exerciseId: testExerciseId.toString(),
          name: testName,
          tags: testTags);

      testExercise.sets.add(testSet1);
      testExercise.sets.add(testSet2);

      testWorkout.exercises.add(testExercise);
    });

    test('Initialisation', () {
      PerformedWorkout workout = PerformedWorkout();
      expect(workout.timestamp, TypeMatcher<int>());
      expect(workout.id, TypeMatcher<String>());
      expect(workout.exercises, []);
      expect(workout.name, Constants.newWorkoutName);
    });

    test('ToJson', () {
      Map<String, Object?> json = testWorkout.toJson();
      expect(json['timestamp'], testTimestamp);
      expect(json['id'], testId);
      expect(json['name'], Constants.newWorkoutName);
      expect(json['exercises'], {testExercise.id: testExercise.toJson()});
      expect(json.keys.length, 4);
    });

    test('FromJson', () {
      Map<String, Object?> json = testWorkout.toJson();
      PerformedWorkout workout = PerformedWorkout.fromJson(json);
      expect(workout.equals(testWorkout), isTrue);
    });
  });
}

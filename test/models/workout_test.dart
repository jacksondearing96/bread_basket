import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter_test/flutter_test.dart';

import '../testUtil.dart';

void main() {
  group('Workout tests', () {
    test('Initialisation', () {
      Workout workout = Workout();
      expect(workout.timestamp, TypeMatcher<int>());
      expect(workout.id, TypeMatcher<String>());
      expect(workout.exercises, []);
      expect(workout.name, Constants.newWorkoutName);
    });

    test('ToJson', () {
      Workout workout = TestUtil.testWorkout();
      Exercise exercise = TestUtil.testExercise();
      Map<String, Object?> json = workout.toJson();
      expect(json['timestamp'], TestUtil.testTimestamp);
      expect(json['id'], TestUtil.testId);
      expect(json['name'], Constants.newWorkoutName);
      expect(json['exercises'], {exercise.id: exercise.toJson()});
      expect(json.keys.length, 4);
    });

    test('FromJson', () {
      Workout workout = TestUtil.testWorkout();
      Map<String, Object?> json = workout.toJson();
      Workout workoutFromJson = Workout.fromJson(json);
      expect(workoutFromJson.equals(workout), isTrue);
    });

    test('Equals', () {
      Workout workout1 = Workout();
      Workout workout2 = Workout();

      expect(workout1.equals(workout2), isFalse);

      workout2.id = workout1.id;
      workout2.timestamp = workout1.timestamp;
      expect(workout1.equals(workout2), isTrue);

      Exercise exercise = TestUtil.testExercise();
      workout1.exercises.add(exercise);
      expect(workout1.equals(workout2), isFalse);

      workout2.exercises.add(exercise);
      expect(workout1.equals(workout2), isTrue);
    });

    test('Clear empty sets and exercises', () {
      Workout testWorkout = TestUtil.testWorkout();
      testWorkout.exercises[0].sets[0].reps = 0;
      testWorkout.clearEmptySetsAndExercises();

      expect(testWorkout.exercises.length, 1);
      expect(
          testWorkout.exercises[0].sets[0].equals(TestUtil.testSet2()), isTrue);

      testWorkout.exercises[0].sets[0].reps = 0;
      testWorkout.clearEmptySetsAndExercises();

      expect(testWorkout.exercises.length, 0);
    }, skip: true);

    test('Total volume', () {
      Workout workout = TestUtil.testWorkout();
      expect(workout.exercises.length, 1);
      expect(workout.exercises[0].sets.length, 2);
      expect(workout.totalVolume(), 130.5);
    });
  });
}

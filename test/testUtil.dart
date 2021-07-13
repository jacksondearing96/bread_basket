import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/screens/workout/workoutSet.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/shared/constants.dart';

class TestUtil {
  static const int testTimestamp = 12345;
  static const String testId = 'testId';
  static String testExerciseId = Constants.deadliftExerciseId.toString();
  static const String testName = Constants.deadliftExerciseName;
  static const List<String> testTags = ['chest', 'shoulders'];
  static PerformedSet _testSet1 = PerformedSet(weight: 10.0, reps: 7);
  static PerformedSet _testSet2 = PerformedSet(weight: 5.5, reps: 11);

  static PerformedSet testSet1() {
    return PerformedSet.from(_testSet1);
  }

  static PerformedSet testSet2() {
    return PerformedSet.from(_testSet2);
  }

  static Exercise testExercise() {
    Exercise exercise = Exercise(
        exerciseId: testExerciseId, name: testName, tags: List.from(testTags));
    exercise.id = testId;
    exercise.timestamp = testTimestamp;
    exercise.sets.add(testSet1());
    exercise.sets.add(testSet2());
    return exercise;
  }

  static Workout testWorkout() {
    Workout workout = Workout();
    workout.timestamp = testTimestamp;
    workout.id = testId;
    workout.exercises.add(testExercise());
    return workout;
  }
}

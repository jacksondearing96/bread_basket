import 'package:bread_basket/models/cardioSession.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
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
  static CardioSession _testCardioSession1 =
      CardioSession(distanceInMetres: 100, duration: Duration(minutes: 5));
  static CardioSession _testCardioSession2 =
      CardioSession(distanceInMetres: 60, duration: Duration(minutes: 4));

  static PerformedSet testSet1() {
    return PerformedSet.from(_testSet1);
  }

  static PerformedSet testSet2() {
    return PerformedSet.from(_testSet2);
  }

  static CardioSession testCardioSession1() {
    return CardioSession.from(_testCardioSession1);
  }

  static CardioSession testCardioSession2() {
    return CardioSession.from(_testCardioSession2);
  }

  static Exercise testExercise() {
    Exercise exercise = Exercise(
        exerciseId: testExerciseId, name: testName, tags: List.from(testTags));
    exercise.id = testId;
    exercise.timestamp = testTimestamp;
    exercise.sets.add(testSet1());
    exercise.sets.add(testSet2());
    exercise.cardioSessions.add(testCardioSession1());
    exercise.cardioSessions.add(testCardioSession2());
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

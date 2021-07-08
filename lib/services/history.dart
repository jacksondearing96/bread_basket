import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';

class HistoryService {
  List<PerformedWorkout> pastWorkouts;

  HistoryService({required this.pastWorkouts});

  List<PerformedWorkout> get workouts => pastWorkouts;

  double totalVolume() {
    return pastWorkouts.fold(
        0, (volume, workout) => volume + workout.totalVolume());
  }

  List<PerformedSet> mostRecentSetsOf(
      {exerciseId: String, bool skipFirstFound = false}) {
    bool isMostRecentExercise = true;
    for (PerformedWorkout workout in pastWorkouts.reversed.toList()) {
      // Want to skip the first item this time because the first item will
      // be the set that we just completed.
      if (skipFirstFound && isMostRecentExercise) {
        isMostRecentExercise = false;
        continue;
      }

      for (PerformedExercise exercise in workout.performedExercises) {
        if (exercise.exercise.id == exercise.id) {
          return exercise.sets;
        }
      }
    }
    return [];
  }

  Map<String, int> workoutDates() {
    Map<String, int> workoutDates = {};
    for (PerformedWorkout workout in pastWorkouts) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(workout.dateInMilliseconds);
      workoutDates.update(Util.dateToStringKey(date), (val) => val + 1,
          ifAbsent: () => 1);
    }
    return workoutDates;
  }

  Map<String, int> muscleGroupToExerciseCounts() {
    Map<String, int> muscleGroupToExerciseCount = {};
    for (PerformedWorkout workout in pastWorkouts) {
      for (PerformedExercise exercise in workout.performedExercises) {
        for (String muscleGroup in Constants.muscleGroups) {
          if (exercise.exercise.tags.contains(muscleGroup)) {
            muscleGroupToExerciseCount.update(
              muscleGroup,
              (existingValue) => existingValue + 1,
              ifAbsent: () => 1,
            );
          }
        }
      }
    }
    return muscleGroupToExerciseCount;
  }

  int totalExerciseCount() {
    return pastWorkouts.fold(
        0,
        (exerciseCount, workout) =>
            exerciseCount + workout.performedExercises.length);
  }

  List<PerformedSet> bestSetFromEveryPastWorkout({exerciseId: String}) {
    List<PerformedSet> bestSetsList = [];
    for (PerformedWorkout workout in pastWorkouts) {
      for (PerformedExercise exercise in workout.performedExercises) {
        if (exercise.exercise.id != exerciseId) continue;
        PerformedSet? maxWeightSet;
        double maxWeight = 0;
        for (PerformedSet performedSet in exercise.sets) {
          // Don't count warm up sets or drop sets.
          if (performedSet.setType == Constants.warmUpCode ||
              performedSet.setType == Constants.dropSetCode) continue;

          // Update the local best weight for this workout.
          if (performedSet.weight > maxWeight) {
            maxWeightSet = performedSet;
            maxWeight = performedSet.weight;
          }
        }
        if (maxWeightSet != null) bestSetsList.add(maxWeightSet);
      }
      if (bestSetsList.length >= Constants.progressGraphDataPointLimit) break;
    }
    return bestSetsList;
  }

  List<double> last7DaysVolumes() {
    List<double> volumes = List.filled(7, 0.0);
    for (PerformedWorkout workout in pastWorkouts.reversed) {
      DateTime now = DateTime.now();
      DateTime workoutTime =
          DateTime.fromMillisecondsSinceEpoch(workout.dateInMilliseconds);
      int difference = now.difference(workoutTime).inDays;
      if (difference >= 7) break;
      volumes[6 - difference] += workout.totalVolume();
    }
    return volumes;
  }
}

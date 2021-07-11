import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';

class RecentHistory {
  List<double> _recentDataPoints = [];

  add(double dataPoint) {
    if (_recentDataPoints.length == 5) _recentDataPoints.removeAt(0);
    _recentDataPoints.add(dataPoint);
  }

  double _mean() {
    return _recentDataPoints.reduce((a, b) => a + b) / _recentDataPoints.length;
  }

  double progressPercentage(double currentDataPoint) {
    double mean = _mean();
    return (currentDataPoint - mean) / mean;
  }

  bool isStatisticallySignificant() {
    return _recentDataPoints.length >= 3 && _mean() != 0;
  }
}

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

      for (Exercise exercise in workout.exercises) {
        if (exercise.exerciseId == exerciseId) {
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
          DateTime.fromMillisecondsSinceEpoch(workout.timestamp);
      workoutDates.update(Util.dateToStringKey(date), (val) => val + 1,
          ifAbsent: () => 1);
    }
    return workoutDates;
  }

  Map<String, int> muscleGroupToExerciseCounts() {
    Map<String, int> muscleGroupToExerciseCount = {};
    for (PerformedWorkout workout in pastWorkouts) {
      for (Exercise exercise in workout.exercises) {
        for (String muscleGroup in Constants.muscleGroups) {
          if (exercise.tags.contains(muscleGroup)) {
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
    return pastWorkouts.fold(0,
        (exerciseCount, workout) => exerciseCount + workout.exercises.length);
  }

  List<PerformedSet> bestSetFromEveryPastWorkout({exerciseId: String}) {
    List<PerformedSet> bestSetsList = [];
    for (PerformedWorkout workout in pastWorkouts) {
      for (Exercise exercise in workout.exercises) {
        if (exercise.exerciseId != exerciseId) continue;
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
          DateTime.fromMillisecondsSinceEpoch(workout.timestamp);
      int difference = now.difference(workoutTime).inDays;
      if (difference >= 7) break;
      volumes[6 - difference] += workout.totalVolume();
    }
    return volumes;
  }

  /*
   * How should this be calculated?
   * 
   * Create a new data point for every workout.
   * Maintain a rolling mean for every exercise.
   * At each workout, use the sum of ratios of differences in the means as the data point.
   * Actually want to plot the area below the curve (cumulative)
   * 
   * Only want to sum for exercises that were actually performed.
   * Would like to only count mean differences if there is at least 3 exercises
   * that have already been used to establish the mean.
   * Would like to constrain increases 
   * l
   * 
   * Maintin a 5-data-point rolling average for each exercise (max weight).
   * Compare each exercise in a workout to this --> get the % inc/dec.
   * Average all the % inc/dec.
   * Plot this cumulatively. 
   */

  List<double> overallWeightProgress() {
    Map<String, RecentHistory> exerciseIdToRecentHistory = {};
    Constants.exerciseList.keys.forEach((exerciseName) =>
        exerciseIdToRecentHistory[Constants.exerciseList[exerciseName]![0]] =
            RecentHistory());

    List<double> graphDataPoints = [];

    pastWorkouts.forEach((workout) {
      List<double> workoutProgressDataPoints = [];
      workout.exercises.forEach((exercise) {
            if (exerciseIdToRecentHistory[exercise.exerciseId]!
                .isStatisticallySignificant()) {
              workoutProgressDataPoints.add(
                  exerciseIdToRecentHistory[exercise.exerciseId]!
                      .progressPercentage(exercise.bestSet().weight));
            }
            exerciseIdToRecentHistory[exercise.exerciseId]!
                .add(exercise.bestSet().weight);
      });
      // Take the mean progress % inc/dec out of all the exercises performed
      // in this workout.
      if (workoutProgressDataPoints.isNotEmpty)
        graphDataPoints.add(workoutProgressDataPoints.reduce((a, b) => a + b) /
            workoutProgressDataPoints.length);
    });

    // Return the cumulative distribution.
    double sum = 0;
    return [for (final val in graphDataPoints) sum += val];
  }

  overallVolumeProgress() {
    Map<String, RecentHistory> exerciseIdToRecentHistory = {};
    Constants.exerciseList.keys.forEach((exerciseName) =>
        exerciseIdToRecentHistory[Constants.exerciseList[exerciseName]![0]] =
            RecentHistory());

    List<double> graphDataPoints = [];

    pastWorkouts.forEach((workout) {
      List<double> workoutProgressDataPoints = [];
      workout.exercises.forEach((exercise) {
            if (exerciseIdToRecentHistory[exercise.exerciseId]!
                .isStatisticallySignificant()) {
              workoutProgressDataPoints.add(
                  exerciseIdToRecentHistory[exercise.exerciseId]!
                      .progressPercentage(exercise.totalVolume()));
            }
            exerciseIdToRecentHistory[exercise.exerciseId]!
                .add(exercise.totalVolume());
      });
      // Take the mean progress % inc/dec out of all the exercises performed
      // in this workout.
      if (workoutProgressDataPoints.isNotEmpty)
        graphDataPoints.add(workoutProgressDataPoints.reduce((a, b) => a + b) /
            workoutProgressDataPoints.length);
    });

    // Return the cumulative distribution.
    double sum = 0;
    return [for (final val in graphDataPoints) sum += val];
  }
}

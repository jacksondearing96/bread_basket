import 'dart:math';

import 'package:bread_basket/models/exerciseCatalog.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bread_basket/models/exercise.dart';

class DatabaseService {
  final String? userId;

  late final Exercise deadlift, squat, benchPress;
  late ExerciseCatalog exerciseCatalog;
  Random _random = new Random();

  DatabaseService({this.userId}) {
    exerciseCatalog =
        _exerciseListFromJson(Constants.exerciseList);

    this.deadlift = exerciseCatalog.exercises
        .where((exercise) =>
            exercise.exerciseId == Constants.deadliftExerciseId.toString())
        .first;
    this.squat = exerciseCatalog.exercises
        .where((exercise) =>
            exercise.exerciseId == Constants.squatExerciseId.toString())
        .first;
    this.benchPress = exerciseCatalog.exercises
        .where((exercise) =>
            exercise.exerciseId == Constants.benchPressExerciseId.toString())
        .first;
  }

  final CollectionReference broCollection =
      FirebaseFirestore.instance.collection('bros');

  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('allExercises');

  ExerciseCatalog _exerciseListFromJson(Map<String, Object?> json) {
    List<Exercise> exercises = json.keys.map((key) {
      List<dynamic> tags =
          ((json[key]) as List).map((elem) => elem as String).toList();
      String id = tags.removeAt(0);
      return Exercise(exerciseId: id, name: key, tags: tags);
    }).toList();
    exercises.sort(
        (a, b) => int.parse(a.exerciseId).compareTo(int.parse(b.exerciseId)));
    return ExerciseCatalog(exercises);
  }

  Stream<ExerciseCatalog> get exercises {
    return exerciseCollection
        .doc('exercises')
        .withConverter<ExerciseCatalog>(
            fromFirestore: (snapshot, _) =>
                _exerciseListFromJson(snapshot.data()!),
            toFirestore: (exercise, _) => {})
        .snapshots()
        .map((snapshot) => snapshot.data() ?? ExerciseCatalog([]));
  }

  Future<bool> saveWorkout(Workout workout) async {
    try {
      await Future.delayed(Duration(milliseconds: 1500));
      await broCollection
          .doc(userId)
          .set({workout.id: workout.toJson()}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Failed to save workout to firebase');
      print(e.toString());
      return false;
    }
  }

  HistoryService _historyFromJson(Map<String, dynamic>? json) {
    if (json == null) return HistoryService(pastWorkouts: []);
    List<Workout> workouts = [];
    for (String id in json.keys) {
      workouts
          .add(Workout.fromJson(json[id]! as Map<String, Object?>));
    }
    workouts.sort((a, b) {
      // It's possible for two workouts to have the same date and therefore
      // timestamp. Therefore, default to the time at which the
      // digital workout was initialised if date is the same.
      if (a.timestamp == b.timestamp) {
        return int.parse(a.id).compareTo(int.parse(b.id));
      }
      return a.timestamp.compareTo(b.timestamp);
    });
    return HistoryService(pastWorkouts: workouts);
  }

  Map<String, dynamic> _historyToJson(HistoryService history) {
    List<Workout> workouts = history.workouts;
    Map<String, dynamic> json = {};
    for (var workout in workouts) {
      json[workout.id] = workout.toJson();
    }
    return json;
  }

  Stream<HistoryService> get history {
    return FirebaseFirestore.instance
        .collection('bros')
        .doc(userId)
        .withConverter<HistoryService>(
            fromFirestore: (snapshot, _) => _historyFromJson(snapshot.data()!),
            toFirestore: (workouts, _) => _historyToJson(workouts))
        .snapshots()
        .map((snapshot) => snapshot.data() ?? HistoryService(pastWorkouts: []));
  }

  PerformedSet _randomSet(int i) {
    double weight =
        60 + double.parse((_random.nextDouble() * 25).toStringAsFixed(1)) - i * 0.25;
    return PerformedSet(weight: weight, reps: 5 + _random.nextInt(5));
  }

  String randomId() => (_random.nextDouble() * 100000000).round().toString();

  Map<String, Object?> _randomWorkout(int daysAgo) {
    Workout workout = Workout();
    workout.timestamp -=
        (daysAgo * 24 * 60 * 60 * 1000 + _random.nextInt(10000)).round();

    Exercise squat2 = Exercise(
        exerciseId: squat.exerciseId, name: squat.name, tags: squat.tags);
    Exercise benchPress2 = Exercise(
        exerciseId: benchPress.exerciseId,
        name: benchPress.name,
        tags: benchPress.tags);
    Exercise deadlift2 = Exercise(
        exerciseId: deadlift.exerciseId,
        name: deadlift.name,
        tags: deadlift.tags);
    for (int j = 0; j < 5; ++j) {
      deadlift2.sets.add(_randomSet(daysAgo));
      squat2.sets.add(_randomSet(daysAgo));
      benchPress2.sets.add(_randomSet(daysAgo));
    }

    if (_random.nextDouble() < 0.2) workout.exercises.addAll([deadlift2, squat2, benchPress2]);

    for (int i = 0; i < 3; ++i) {
      Exercise exercise = exerciseCatalog
          .exercises[_random.nextInt(exerciseCatalog.exercises.length)];
      Exercise exercise2 = Exercise(
          exerciseId: exercise.exerciseId,
          name: exercise.name,
          tags: exercise.tags);
      for (int j = 0; j < 3; ++j) {
        exercise2.sets.add(_randomSet(daysAgo));
      }
      workout.exercises.add(exercise2);
    }

    return workout.toJson();
  }

  void addDataToDemoAccount() async {
    print('Adding data to demo account.');
    Map<String, Object?> workouts = {};
    for (int i = 0; i < 90; ++i) {
      if (_random.nextInt(100) < 50) {
        final workout = _randomWorkout(i);
        workouts[workout['id']! as String] = workout;
      }
      if (_random.nextInt(100) < 20) {
        final workout = _randomWorkout(i);
        workouts[workout['id']! as String] = workout;
      }
      if (_random.nextInt(100) < 5) {
        final workout = _randomWorkout(i);
        workouts[workout['id']! as String] = workout;
      }
    }
    print('${workouts.keys.length} workouts to upload.');
    try {
      await broCollection.doc(userId).set(workouts);
    } catch (e) {
      print('Failed to save workout to firebase');
      print(e.toString());
    }
  }

  void uploadExercises() {
    bool upload = false;
    if (!upload) return;
    print('Uploading exercises:');
    exerciseCollection
        .doc('exercises')
        .set(exerciseList, SetOptions(merge: true));
  }

  Map<String, List<String>> exerciseList = {
    'assisted_chin_up_(machine)': ['5160', 'biceps', 'back'],
    'back_extension_(bodyweight)': ['5122', 'back'],
    'back_extension_(machine)': ['5156', 'back'],
    'bent_over_row_(barbell)': ['1127', 'back'],
    'bent_over_row_(dumbbell)': ['4087', 'back'],
    'bent_over_row_(dumbbell_single_arm)': ['5052', 'back'],
    'bent_over_row_(machine)': ['3100', 'back'],
    'stiff_leg_deadlift_(barbell)': ['2139', 'legs', 'back'],
    'high_standing_row_(cable)': ['4071', 'back'],
    'inverted_pull_up_(bodyweight_under_grip)': ['5002', 'back'],
    'lat_pulldown_(cable_close_grip)': ['4053', 'back'],
    'lat_pulldown_(cable_single_arm)': ['3013', 'back'],
    'lat_pulldown_(cable_under_grip)': ['4028', 'back'],
    'lat_pulldown_(cable_v_grip)': ['3036', 'back'],
    'lat_pulldown_(cable_wide_grip)': ['1049', 'back'],
    'lat_pulldown_(iso-lateral_machine_under_grip)': ['3153', 'back'],
    'lat_pulldown_(machine)': ['2061', 'back'],
    'lat_pulldown_behind_neck_(cable)': ['5039', 'back'],
    'pull_up_(bodyweight)': ['1069', 'back'],
    'pull_up_(behind_neck)': ['5023', 'back'],
    'row_(cable_single_arm)': ['3044', 'back'],
    'seated_row_(iso-lateral_machine)': ['3124', 'back'],
    'seated_row_(machine)': ['1143', 'back'],
    'seated_row_(cable)': ['1208', 'back'],
    'straight_arm_pulldown_(cable)': ['3133', 'back'],
    'deadlift_(barbell)': ['1'],
    'bicep_curl_(barbell)': ['1125', 'biceps'],
    'bicep_curl_(cable)': ['3150', 'biceps'],
    'bicep_curl_(dumbbell)': ['1057', 'biceps'],
    'bicep_curl_(ez_bar)': ['2081', 'biceps'],
    'bicep_curl_(machine)': ['3050', 'biceps'],
    'bicep_curl_(tricep_bar)': ['5080', 'biceps'],
    'chin_up_(bodyweight)': ['3005', 'back', 'biceps'],
    'hammer_curls_(dumbbell)': ['3027', 'biceps'],
    'high_bicep_curl_(cable)': ['5158', 'biceps'],
    'incline_seated_bicep_curl_(dumbbell)': ['3034', 'biceps'],
    'isoloation_curl_(dumbbell)': ['2105', 'biceps'],
    'preacher_curl_(dumbbell_single_arm)': ['3029', 'biceps'],
    'preacher_curl_(ez_bar)': ['1067', 'biceps'],
    'prone_incline_bicep_curl_(barbell)': ['5031', 'biceps'],
    'standing_overhead_curl_(cable)': ['5001', 'biceps'],
    'two_handed_plate_curl': ['5102', 'biceps'],
    'assisted_dip_(machine)': ['5089', 'triceps', 'chest'],
    'bench_press_(barbell)': ['35', 'chest'],
    'bench_press_(close_grip)': ['4120', 'chest', 'triceps'],
    'bench_press_(smith_machine)': ['4021', 'chest'],
    'cable_fly_(cable)': ['1117', 'chest'],
    'cable_fly_(cable_high_to_low)': ['2042', 'chest'],
    'cable_fly_(cable_low_to_high)': ['2116', 'chest'],
    'chest_dip_(bodyweight)': ['3101', 'chest'],
    'chest_fly_(dumbbell)': ['1113', 'chest'],
    'chest_fly_(machine)': ['2054', 'chest'],
    'chest_press_(dumbbell)': ['1112', 'chest'],
    'chest_press_(machine)': ['2025', 'chest'],
    'decline_bench_press_(barbell)': ['2040', 'chest'],
    'decline_bench_press_(smith_machine)': ['5083', 'chest'],
    'dip_(bodyweight)': ['1046', 'triceps', 'chest'],
    'incline_bench_press_(barbell)': ['2129', 'chest'],
    'incline_bench_press_(smith_machine)': ['5048', 'chest'],
    'incline_bench_row_(dumbbell)': ['5004', 'back'],
    'incline_chest_fly_(dumbbell)': ['3020', 'chest'],
    'incline_chest_press_(dumbbell)': ['2072', 'chest'],
    'iso-lateral_chest_press_(machine)': ['3103', 'chest'],
    'pull_over_(barbell)': ['5012', 'chest'],
    'pull_over_(dumbbell)': ['3146', 'chest'],
    'push_up_(bodyweight)': ['1209', 'chest', 'core'],
    'push_up_(bodyweight_diamond)': ['3211', 'triceps', 'chest'],
    'push_up_(bodyweight_close_grip_tricep_focus)': [
      '3212',
      'chest',
      'triceps'
    ],
    'arnold_press_(dumbbell)': ['3037', 'shoulders'],
    'bent_over_reverse_fly_(cable)': ['5104', 'back', 'shoulders'],
    'bent_over_reverse_fly_(dumbbell)': ['5058', 'back', 'shoulders'],
    'front_raise_(cable)': ['4065', 'shoulders'],
    'iso-lateral_shoulder_press_(machine)': ['3136', 'shoulders'],
    'lateral_raise_(cable)': ['2099', 'shoulders'],
    'lateral_raise_(cable_single_arm)': ['2107', 'shoulders'],
    'lateral_raise_(dumbbell)': ['1106', 'shoulders'],
    'lateral_raise_(machine)': ['5131', 'shoulders'],
    'low_standing_row_(cable)': ['5024', 'back', 'shoulders'],
    'neutral_shoulder_press_(dumbbell)': ['4022', 'shoulders'],
    'reverse_fly_(cable)': ['3154', 'shoulders'],
    'reverse_fly_(machine)': ['2077', 'shoulders'],
    'seated_overhead_tricep_extension_(dumbbell)': ['2088', 'shoulders'],
    'seated_shoulder_press_(barbell)': ['5026', 'shoulders'],
    'seated_shoulder_press_(smith_machine)': ['5119', 'shoulders'],
    'shoulder_press_(dumbbell)': ['1059', 'shoulders'],
    'shoulder_press_behind_the_neck_(barbell)': ['5094', 'shoulders'],
    'shrug_(barbell)': ['3140', 'shoulders'],
    'shrug_(dumbbell)': ['2130', 'shoulders'],
    'front_raise_(dumbbell_two-handed)': ['5011', 'shoulders'],
    'upright_row_(barbell)': ['2008', 'shoulders'],
    'calf_raise_(dumbbell)': ['2144', 'legs'],
    'calf_raise_(hack_squat_machine)': ['4163', 'legs'],
    'calf_raise_(leg_press_machine)': ['3110', 'legs'],
    'calf_raise_(machine)': ['2118', 'legs'],
    'calf_raise_(smith_machine)': ['5138', 'legs'],
    'deadlift_(smith_machine)': ['5075', 'back', 'legs'],
    'front_squat_(barbell)': ['5092', 'legs'],
    'hack_squat_(machine)': ['4114', 'legs'],
    'hamstring_curl_(machine)': ['2017', 'legs'],
    'hip_adduction_(machine)': ['5009', 'legs'],
    'leg_extension_(machine)': ['1014', 'legs'],
    'leg_press_(machine)': ['1137', 'legs'],
    'lunge_(barbell)': ['3006', 'legs'],
    'lunge_(dumbbell)': ['2074', 'legs'],
    'seated_calf_raise_(machine_plate_loaded)': ['2066', 'legs'],
    'single_leg_squat_(dumbbell)': ['5007', 'legs'],
    'squat_(barbell)': ['151', 'legs'],
    'squat_(dumbbell)': ['4145', 'legs'],
    'standing_straight_leg_kickback_(cable)': ['5082', 'legs'],
    'step_up_(dumbbell)': ['3115', 'legs'],
    'sumo_squat_(barbell)': ['3142', 'legs'],
    'hip_thrust_(barbell)': ['2203', 'legs'],
    'bulgarian_split_squat_(dumbbell)': ['2204', 'legs'],
    'exercise_bike': ['5090', 'cardio'],
    'running': ['5123', 'cardio'],
    'treadmill': ['5126', 'cardio'],
    'skipping': ['5157', 'cardio'],
    'ab_wheel_(bodyweight)': ['6141', 'core'],
    'bench_v_sit_crunch_(bodyweight)': ['6079', 'core'],
    'burpee_(bodyweight)': ['6003', 'core'],
    'cable_crunch_(cable)': ['6147', 'core'],
    'captains_chair_cross_body_knee_raise_(bodyweight)': ['6161', 'core'],
    'captains_chair_knee_raise_(bodyweight)': ['6109', 'core'],
    'cross_body_crunch_(bodyweight)': ['6111', 'core'],
    'crunch_(bodyweight)': ['6097', 'core'],
    'crunch_(bodyweight_ab_board)': ['6098', 'core'],
    'crunch_(machine)': ['6152', 'core'],
    'decline_sit_up_(bodyweight)': ['6045', 'core'],
    'exercise_ball_feet-hand_pass': ['6135', 'core'],
    'exercise_ball_knee_roll_(bodyweight)': ['6132', 'core'],
    'flat_leg_raise_(bodyweight)': ['6062', 'core'],
    'hanging_cross_body_leg_raises_(bodyweight)': ['6056', 'core'],
    'hanging_knee_raise_(bodyweight)': ['6063', 'core'],
    'hanging_toes_to_bar_(bodyweight)': ['6047', 'core'],
    'heel_taps_(bodyweight)': ['6010', 'core'],
    'incline_leg_raises_(bodyweight)': ['6015', 'core'],
    'incline_oblique_crunch_(bodyweight)': ['6108', 'core'],
    'lying_knee_raise_(bodyweight)': ['6091', 'core'],
    'mountain_climbers_(bodyweight)': ['6159', 'core'],
    'nordic_(bodyweight)': ['6043', 'core'],
    'oblique_crunch_(medicine_ball)': ['6096', 'core'],
    'prone_leg_extension_(bodyweight)': ['6051', 'legs', 'core'],
    'prone_leg_extension_(bodyweight_bench)': ['6060', 'legs', 'core'],
    'reverse_crunch_(bodyweight)': ['6073', 'core'],
    'russian_twist': ['6032', 'core'],
    'scissor_leg_raise_(bodyweight)': ['6055', 'core'],
    'seated_abdominal_twist_(barbell)': ['6070', 'core'],
    'side-lying_leg_raise_(bodyweight)': ['6162', 'legs', 'core'],
    'single-leg_v_up_(bodyweight)': ['6085', 'core'],
    'sit_up_(medicine_ball)': ['6078', 'core'],
    'standing_oblique_crunch_(dumbbell)': ['6038', 'core'],
    'standing_plate_twist': ['6155', 'core'],
    'standing_twist_(barbell)': ['6095', 'core'],
    'straight_leg_kickback_(bodyweight)': ['6148', 'legs', 'core'],
    'v_up_(bodyweight)': ['6093', 'core'],
    'bench_dip_(bodyweight)': ['5134', 'triceps'],
    'bent_over_overhead_tricep_extension_(cable)': ['3210', 'triceps'],
    'overhead_tricep_extension_(dumbbell_single_arm)': ['3068', 'triceps'],
    'overhead_tricep_extension_(ez_bar)': ['4018', 'triceps'],
    'overhead_tricep_extension_(tricep_bar)': ['4086', 'triceps'],
    'skull_crusher_(barbell)': ['1041', 'triceps'],
    'seated_tricep_pushdown_(machine)': ['5033', 'triceps', 'chest'],
    'skull_crusher_(dumbbell)': ['5076', 'triceps'],
    'skull_crusher_(ez_bar)': ['1084', 'triceps'],
    'tricep_extension_(cable_flat_bar)': ['1121', 'triceps'],
    'tricep_extension_(cable_v_bar)': ['1201', 'triceps'],
    'tricep_extension_(cable_rope)': ['1202', 'triceps'],
    'tricep_extension_(cable_single_arm)': ['2016', 'triceps'],
    'tricep_extension_(machine)': ['4128', 'triceps'],
    'tricep_kickback_(dumbbell)': ['2149', 'triceps'],
    'wrist_curl_(barbell)': ['5064', 'forearms'],
  };
}

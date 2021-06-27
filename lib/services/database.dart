import 'package:bread_basket/models/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bread_basket/models/exercise.dart';

class DatabaseService {
  final String? userId;
  DatabaseService({this.userId});

  final CollectionReference broCollection =
      FirebaseFirestore.instance.collection('bros');

  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercises');

  List<Exercise> _exerciseListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Exercise(id: doc.id, name: doc['name'], tags: doc['tags']))
        .toList();
  }

  // Get exercises stream.
  Stream<List<Exercise>> get exercises {
    return exerciseCollection.snapshots().map(_exerciseListFromQuerySnapshot);
  }

  void saveWorkout(PerformedWorkout workout) {
    workout.log('Saving workout:');

    for (var exercise in workout.performedExercises) {
      for (var set in exercise.sets) {
        print('attempting save of set');
        broCollection
            .doc(userId)
            .collection('workouts')
            .doc(workout.id)
            .collection('exercises')
            .doc(exercise.id)
            .collection('sets')
            .add({
          'type': set.setType,
          'weight': set.weight,
          'reps': set.reps
        }).then((value) => print('Saved set: ${value.id}'));
      }
    }
  }

  // Get exercise list for a workout.
  // Stream<List<Exercise>> getWorkout({ workoutId: workoutId }) {
  //   return broCollection
  //     .doc(userId)
  //     .collection('workouts')
  //     .doc(workoutId)
  // }

  void uploadExercises() {
    print('Uploading exercises:');
    for (String exercise_name in exerciseList.keys) {
      List<String>? list = exerciseList[exercise_name];
      if (list == null) return;
      String id = list.removeAt(0);
      List<String> tags = list;

      exerciseCollection.doc(id).set({
        'name': exercise_name,
        'tags': tags,
      });
      print('Uploaded: $exercise_name (id=$id, tags=$tags)');
    }
  }

  Map<String, List<String>> exerciseList = {
    'standing_overhead_cable_curl': ['1', 'biceps'],
    'inverted_pull_up_(under_grip)': ['2', 'back'],
    'burpee': ['3', 'core'],
    'incline_bench_row_(dumbbell)': ['4', 'back'],
    'chin_up': ['5', 'back', 'biceps'],
    'lunge_(barbell)': ['6', 'legs'],
    'single_leg_squat_(dumbbell)': ['7', 'legs'],
    'upright_row_(barbell)': ['8', 'shoulders'],
    'hip_adduction_(machine)': ['9', 'legs'],
    'heel_taps': ['10', 'core'],
    'two-handed_front_raise_(dumbbell)': ['11', 'shoulders'],
    'pull_over_(barbell)': ['12', 'chest'],
    'single_arm_lat_pulldown_(cable)': ['13', 'back'],
    'leg_extension_(machine)': ['14', 'legs'],
    'incline_leg_raises': ['15', 'core'],
    'single_arm_tricep_extension_(cable)': ['16', 'triceps'],
    'hamstring_curl_(machine)': ['17', 'legs'],
    'overhead_tricep_extension_(ez_bar)': ['18', 'triceps'],
    'preacher_curl_(cable)': ['19', 'biceps'],
    'incline_chest_fly_(dumbbell)': ['20', 'chest'],
    'bench_press_(smith_machine)': ['21', 'chest'],
    'neutral_shoulder_press_(dumbbell)': ['22', 'shoulders'],
    'pull_up_(behind_neck)': ['23', 'back'],
    'low_standing_row_(cable)': ['24', 'back', 'shoulders'],
    'chest_press_(machine)': ['25', 'chest'],
    'seated_shoulder_press_(barbell)': ['26', 'shoulders'],
    'hammer_curls': ['27', 'biceps'],
    'lat_pulldown_(under_grip)': ['28', 'back'],
    'single_arm_preacher_curl_(dumbbell)': ['29', 'biceps'],
    'chest_fly_(cable)': ['30', 'chest'],
    'prone_incline_bicep_curl_(barbell)': ['31', 'biceps'],
    'russian_twist': ['32', 'core'],
    'seated_tricep_pushdown_(machine)': ['33', 'triceps', 'chest'],
    'incline_seated_bicep_curl_(dumbbell)': ['34', 'biceps'],
    'bench_press': ['35', 'chest'],
    'lat_pulldown_(v_grip)': ['36', 'back'],
    'arnold_press': ['37', 'shoulders'],
    'standing_oblique_crunch_(dumbbell)': ['38', 'core'],
    'lat_pulldown_behind_neck_(cable)': ['39', 'back'],
    'decline_bench_press': ['40', 'chest'],
    'scull_crusher_(barbell)': ['41', 'triceps'],
    'lower_chest_cable_crossover': ['42', 'chest'],
    'nordic': ['43', 'core'],
    'single_arm_row_(cable)': ['44', 'back'],
    'decline_sit_up': ['45', 'core'],
    'dip': ['46', 'triceps', 'chest'],
    'hanging_toes_to_bar': ['47', 'core'],
    'incline_bench_press_(smith_machine)': ['48', 'chest'],
    'lat_pulldown_(cable_wide_grip)': ['49', 'back'],
    'bicep_curl_(machine)': ['50', 'biceps'],
    'prone_leg_extension': ['51', 'legs', 'core'],
    'single_arm_bent_over_row_(dumbbell)': ['52', 'back'],
    'lat_pulldown_(cable_close_grip)': ['53', 'back'],
    'chest_fly_(machine)': ['54', 'chest'],
    'scissor_leg_raise': ['55', 'core'],
    'hanging_cross_body_leg_raises': ['56', 'core'],
    'bicep_curl_(dumbbell)': ['57', 'biceps'],
    'bent_over_reverse_fly_(dumbbell)': ['58', 'back', 'shoulders'],
    'shoulder_press_(dumbbell)': ['59', 'shoulders'],
    'prone_leg_extension_(bench)': ['60', 'legs', 'core'],
    'lat_pulldown_(machine)': ['61', 'back'],
    'flat_leg_raise': ['62', 'core'],
    'hanging_knee_raise': ['63', 'core'],
    'wrist_curl_(barbell)': ['64', 'forearms'],
    'front_raise_(cable)': ['65', 'shoulders'],
    'seated_calf_raise_(plate_loaded)': ['66', 'legs'],
    'preacher_curl': ['67', 'biceps'],
    'single_arm_overhead_tricep_extension_(dumbbell)': ['68', 'triceps'],
    'pull_up': ['69', 'back'],
    'seated_abdominal_twist_(barbell)': ['70', 'core'],
    'high_standing_row_(cable)': ['71', 'back'],
    'incline_chest_press_(dumbbell)': ['72', 'chest'],
    'reverse_crunch': ['73', 'core'],
    'lunge_(dumbbell)': ['74', 'legs'],
    'deadlift_(smith_machine)': ['75', 'back', 'legs'],
    'skull_crusher_(dumbbell)': ['76', 'triceps'],
    'reverse_fly_(machine)': ['77', 'shoulders'],
    'sit_up_(medicine_ball)': ['78', 'core'],
    'bench_v_sit_crunch': ['79', 'core'],
    'bicep_curl_(tricep_bar)': ['80', 'biceps'],
    'bicep_curl_(ez_bar)': ['81', 'biceps'],
    'standing_straight_leg_kickback_(cable)': ['82', 'legs'],
    'decline_bench_press_(smith_machine)': ['83', 'chest'],
    'skull_crusher': ['84', 'triceps'],
    'single-leg_v_up': ['85', 'core'],
    'overhead_tricep_extension_(tricep_bar)': ['86', 'triceps'],
    'bent_over_row_(dumbbell)': ['87', 'back'],
    'seated_overhead_tricep_extension_(dumbbell)': ['88', 'shoulders'],
    'assisted_dip': ['89', 'triceps', 'chest'],
    'exercise_bike': ['90', 'cardio'],
    'lying_knee_raise': ['91', 'core'],
    'front_squat': ['92', 'legs'],
    'v_up': ['93', 'core'],
    'shoulder_press_behind_the_neck': ['94', 'shoulders'],
    'standing_twist_(barbell)': ['95', 'core'],
    'oblique_crunch_(medicine_ball)': ['96', 'core'],
    'crunch': ['97', 'core'],
    'crunch_(ab_board)': ['98', 'core'],
    'lateral_raise_(cable)': ['99', 'shoulders'],
    'bent_over_row_(machine)': ['100', 'back'],
    'chest_dip': ['101', 'chest'],
    'two_handed_plate_curl': ['102', 'biceps'],
    'iso-lateral_chest_press_(machine)': ['103', 'chest'],
    'bent_over_reverse_fly_(cable)': ['104', 'back', 'shoulders'],
    'isoloation_curl': ['105', 'biceps'],
    'lateral_raise_(dumbbell)': ['106', 'shoulders'],
    'single_arm_lateral_raise_(cable)': ['107', 'shoulders'],
    'incline_oblique_crunch': ['108', 'core'],
    'captains_chair_knee_raise': ['109', 'core'],
    'calf_raise_(leg_press_machine)': ['110', 'legs'],
    'cross_body_crunch': ['111', 'core'],
    'chest_press_(dumbbell)': ['112', 'chest'],
    'chest_fly_(dumbbell)': ['113', 'chest'],
    'hack_squat': ['114', 'legs'],
    'step_up_(dumbbell)': ['115', 'legs'],
    'cable_fly_low_to_high': ['116', 'chest'],
    'cable_fly': ['117', 'chest'],
    'calf_raise': ['118', 'legs'],
    'seated_shoulder_press_(smith_machine)': ['119', 'shoulders'],
    'bench_press_(close_grip)': ['120', 'chest', 'triceps'],
    'tricep_extension_(cable)': ['121', 'triceps'],
    'back_extension': ['122', 'back'],
    'running': ['123', 'cardio'],
    'iso-lateral_row_(machine)': ['124', 'back'],
    'bicep_curl_(barbell)': ['125', 'biceps'],
    'treadmill': ['126', 'cardio'],
    'bent_over_row_(barbell)': ['127', 'back'],
    'tricep_extension_(machine)': ['128', 'triceps'],
    'incline_bench_press': ['129', 'chest'],
    'shrug_(dumbbell)': ['130', 'shoulders'],
    'lateral_raise_(machine)': ['131', 'shoulders'],
    'exercise_ball_knee_roll': ['132', 'core'],
    'straight_arm_pulldown_(cable)': ['133', 'back'],
    'bench_dip': ['134', 'triceps'],
    'exercise_ball_feet-hand_pass': ['135', 'core'],
    'iso-lateral_shoulder_press_(machine)': ['136', 'shoulders'],
    'leg_press': ['137', 'legs'],
    'calf_raise_(smith_machine)': ['138', 'legs'],
    'deadlift': ['139', 'legs', 'back'],
    'shrug_(barbell)': ['140', 'shoulders'],
    'ab_wheel': ['141', 'core'],
    'sumo_squat': ['142', 'legs'],
    'seated_row_(machine)': ['143', 'back'],
    'calf_raise_(machine)': ['144', 'legs'],
    'squat_(dumbbell)': ['145', 'legs'],
    'pull_over_(dumbbell)': ['146', 'chest'],
    'cable_crunch': ['147', 'core'],
    'straight_leg_kickback': ['148', 'legs', 'core'],
    'tricep_kickback_(dumbbell)': ['149', 'triceps'],
    'bicep_curl_(cable)': ['150', 'biceps'],
    'squat': ['151', 'legs'],
    'crunch_(machine)': ['152', 'core'],
    'iso-lateral_lat_pulldown_(machine_under_grip)': ['153', 'back'],
    'reverse_fly_(cable)': ['154', 'shoulders'],
    'standing_plate_twist': ['155', 'core'],
    'back_extension_(machine)': ['156', 'back'],
    'skipping': ['157', 'cardio'],
    'high_bicep_curl_(cable)': ['158', 'biceps'],
    'mountain_climbers': ['159', 'core'],
    'assisted_chin_up': ['160', 'biceps', 'back'],
    'captains_chair_cross_body_knee_raise': ['161', 'core'],
    'side-lying_leg_raise': ['162', 'legs', 'core'],
    'calf_raise_(hack_squat_machine)': ['163', 'legs']
  };
}

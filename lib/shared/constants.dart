import 'package:flutter/material.dart';

class Constants {
  static Color backgroundColor = Color.fromARGB(255, 30, 30, 30);
  static Color lighterBackground =
      Color.fromARGB(255, 255, 255, 255).withOpacity(0.9);
  static const Color accentColor = Colors.blueAccent;

  static const Color primaryColor = Colors.lightBlueAccent;
  static const Color secondaryColor = Colors.greenAccent;

  static const Color textColor = Colors.white;
  static const Color textColorTemp = Colors.pink;
  static const Color hintColorTemp = Colors.purple;
  static const Color hintColor = Colors.grey;
  static const Color errorColor = Colors.red;
  static const Color warmUpSetTypeColor = Colors.orange;
  static const Color dropSetSetTypeColor = Colors.purple;
  static const Color failureSetTypeColor = Colors.red;
  static const Color normalSetTypeColor = hintColor;
  static Color darkIconColor = Colors.black.withAlpha(140);
  static Color darkSecondaryBackground =
      Color.fromARGB(255, 66, 66, 66).withAlpha(120);
  static Color floatingActionButtonColor = Colors.white;

  static Gradient themeGradient = LinearGradient(
    colors: <Color>[
      Constants.primaryColor.withOpacity(0.9),
      Constants.secondaryColor.withOpacity(0.9)
    ],
  );

  static const Color progressGraphBackgroundColor = Colors.transparent;
  static Color progressGraphGridLineColor = Color.fromARGB(200, 45, 45, 45);
  static const Color progressGraphBorderColor = Color.fromARGB(200, 40, 40, 40);

  static const InputDecoration textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: hintColor),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.primaryColor,
        width: 1.0,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: textColor,
        width: 1.0,
      ),
    ),
  );

  static const InputDecoration setInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: hintColor),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.primaryColor,
        width: 1.0,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Constants.secondaryColor,
        width: 1.0,
      ),
    ),
  );

  static const double selectExerciseFontSize = 16.0;

  static const double workoutSetTypeDropdownWidth = 65.0;
  static const double workoutSetInputWidth = 48.0;
  static const double prevSetWidth = 76.0;
  static const double exerciseTypeIconWidth = 32.0;
  static double exerciseTypeIconHeight(String iconLocation) {
    if (iconLocation == 'resources/icons/body.png') return 44;
    return 32.0;
  }

  static const double selectExerciseImageWidth = 120.0;
  static const double selectExerciseImageHeight = 80.0;
  static const double workoutExerciseImageWidth = 90.0;
  static const double workoutExerciseImageHeight = 60.0;
  static const double progressIndicatorIconWidth = 20.0;
  static const double progressIndicatorIconHeight = 20.0;

  static const double largeButtonWidth = 220;
  static const double largeButtonHeight = 60;

  static const double equipmentTypeIconOpacity = 0.4;

  static const int progressGraphDataPointLimit = 20;

  static const String warmUpCode = 'W';
  static const String dropSetCode = 'D';
  static const String failureCode = 'F';
  static const String normalCode = 'N';

  static const List<String> equipmentTypes = [
    'dumbbell',
    'barbell',
    'cable',
    'ez_bar',
    'machine',
    'bodyweight'
  ];
  static Map<String, String> equipmentTypeIcons = {
    'dumbbell': 'resources/icons/dumbbell.png',
    'barbell': 'resources/icons/barbell.png',
    'cable': 'resources/icons/cable.png',
    'machine': 'resources/icons/cog.png',
    'ez_bar': 'resources/icons/ez_bar.png',
    'bodyweight': 'resources/icons/body.png',
  };

  static const List<String> muscleGroups = [
    'legs',
    'chest',
    'triceps',
    'biceps',
    'shoulders',
    'back',
    'core',
  ];

  static const int benchPressExerciseId = 35;
  static const int deadliftExerciseId = 1;
  static const int squatExerciseId = 151;

  static List<Color> pieChartColors = [
    Constants.primaryColor,
    Constants.secondaryColor,
    Colors.purpleAccent[100]!,
    Colors.lightBlueAccent[700]!,
    Colors.greenAccent[400]!,
    Colors.blueAccent,
    Colors.greenAccent[100]!,
  ];

  static String weightIcon = 'resources/icons/weight.png';
  static String dumbbellIcon = 'resources/icons/dumbbell.png';
  static String sigmaIcon = 'resources/icons/sigma.png';
  static Image backgroundImage = Image.asset('resources/icons/background.png');

  static AppBar gradientAppBar({title, actions, leading}) {
    return AppBar(
      leading: leading ?? null,
      title: title ?? Container(),
      flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
            Constants.secondaryColor,
            Constants.primaryColor,
          ]))),
      elevation: 0.0,
      actions: actions ?? [],
    );
  }

  static Map<String, List<String>> exerciseList = {
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

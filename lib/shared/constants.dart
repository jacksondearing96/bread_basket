import 'package:flutter/material.dart';

class Constants {
  static Color backgroundColor = Color.fromARGB(255, 20, 20, 20);
  static Color lighterBackground =
      Color.fromARGB(255, 255, 255, 255).withOpacity(0.9);
  static const Color accentColor = Colors.blueAccent;
  static const Color textColor = Colors.white;
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
      Colors.lightBlueAccent.withOpacity(0.9),
      Colors.greenAccent.withOpacity(0.9)
    ],
  );
  // Progress graph dark theme.
  // static const Color progressGraphBackgroundColor = Color(0xff232d37);
  // static const Color progressGraphGridLineColor = Color(0xff37434d);
  // static const Color progressGraphBorderColor = Color(0xff37434d);

  // Progress graph light theme.
  static const Color progressGraphBackgroundColor = Colors.transparent;
  static Color progressGraphGridLineColor = Color.fromARGB(200, 45, 45, 45);
  static const Color progressGraphBorderColor = Color.fromARGB(200, 40, 40, 40);

  static const InputDecoration textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: hintColor),
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
        color: Colors.lightBlueAccent,
        width: 1.0,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.greenAccent,
        width: 1.0,
      ),
    ),
  );

  static const double selectExerciseFontSize = 16.0;

  static const double workoutSetTypeDropdownWidth = 65.0;
  static const double workoutSetInputWidth = 45.0;
  static const double prevSetWidth = 80.0;
  static const double exerciseTypeIconWidth = 32.0;
  static const double selectExerciseImageWidth = 120.0;
  static const double selectExerciseImageHeight = 80.0;
  static const double workoutExerciseImageWidth = 90.0;
  static const double workoutExerciseImageHeight = 60.0;
  static const double progressIndicatorIconWidth = 20.0;
  static const double progressIndicatorIconHeight = 20.0;

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
    'machine'
  ];
  static Map<String, String> equipmentTypeIcons = {
    'dumbbell': 'resources/icons/dumbbell.png',
    'barbell': 'resources/icons/barbell.png',
    'cable': 'resources/icons/cable.png',
    'machine': 'resources/icons/cog.png',
    'ez_bar': 'resources/icons/ez_bar.png'
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

  static List<Color> pieChartColors = [
    Colors.lightBlueAccent,
    Colors.greenAccent,
    Colors.purpleAccent[100]!,
    Colors.lightBlueAccent[700]!,
    Colors.greenAccent[400]!,
    Colors.blueAccent,
    Colors.greenAccent[100]!,
  ];

  static String weightIcon = 'resources/icons/weight.png';
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
            Colors.greenAccent,
            Colors.lightBlueAccent,
          ]))),
      elevation: 0.0,
      actions: actions ?? [],
    );
  }
}

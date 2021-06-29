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
  static const Color normalSetTypeColor = Colors.black;
  static Color darkIconColor = Colors.black.withAlpha(135);

  // Progress graph dark theme.
  // static const Color progressGraphBackgroundColor = Color(0xff232d37);
  // static const Color progressGraphGridLineColor = Color(0xff37434d);
  // static const Color progressGraphBorderColor = Color(0xff37434d);

  // Progress graph light theme.
  static const Color progressGraphBackgroundColor = Colors.white;
  static Color progressGraphGridLineColor = Color.fromARGB(255, 244, 244, 244);
  static const Color progressGraphBorderColor =
      Color.fromARGB(255, 230, 230, 230);

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
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: textColor,
        width: 1.0,
      ),
    ),
  );

  static const double selectExerciseFontSize = 16.0;

  static const double workoutSetTypeDropdownWidth = 65.0;
  static const double workoutSetInputWidth = 45.0;
  static const double prevSetWidth = 80.0;
  static const double exerciseTypeIconWidth = 15.0;
  static const double selectExerciseImageWidth = 120.0;
  static const double selectExerciseImageHeight = 80.0;
  static const double workoutExerciseImageWidth = 90.0;
  static const double workoutExerciseImageHeight = 60.0;
  static const double progressIndicatorIconWidth = 20.0;
  static const double progressIndicatorIconHeight = 20.0;

  static const double equipmentTypeIconOpacity = 0.4;

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
  static Map<String, Image> equipmentTypeIcons = {
    'dumbbell': Image.asset('resources/icons/dumbbell.png'),
    'barbell': Image.asset('resources/icons/barbell.png'),
    'cable': Image.asset('resources/icons/cable.png'),
    'machine': Image.asset('resources/icons/cog.png'),
    'ez_bar': Image.asset('resources/icons/ez_bar.png')
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

  static const List<Color> pieChartColors = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Colors.red,
    Colors.cyan,
    Colors.yellow
  ];

  static Image weightIcon = Image.asset('resources/icons/weight.png');
  static Image sigmaIcon = Image.asset('resources/icons/sigma.png');
  static Image backgroundImage = Image.asset('resources/icons/background.png');
}

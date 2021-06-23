import 'package:flutter/material.dart';

class Constants {
  static const Color backgroundColor = Color.fromARGB(255, 60, 60, 60);
  static const Color accentColor = Colors.blueAccent;
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.grey;
  static const Color errorColor = Colors.red;
  static const Color warmUpSetTypeColor = Colors.orange;
  static const Color dropSetSetTypeColor = Colors.purple;
  static const Color failureSetTypeColor = Colors.red;
  static const Color normalSetTypeColor = Colors.black;

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

  static const double workoutSetTypeDropdownWidth = 65.0;
  static const double workoutSetInputWidth = 45.0;

  static const String warmUpCode = 'W';
  static const String dropSetCode = 'D';
  static const String failureCode = 'F';
  static const String normalCode = 'N';
}

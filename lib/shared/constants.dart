import 'package:flutter/material.dart';

class Constants {
  static const Color backgroundColor = Color.fromARGB(255, 60, 60, 60);
  static const Color accentColor = Colors.blueAccent;
  static const Color textColor = Colors.white;
  static const Color hintColor = Colors.grey;
  static const Color errorColor = Colors.red;

  static const InputDecoration textInputDecoration = InputDecoration(
      hintStyle: TextStyle(color: hintColor),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: textColor,
          width: 1.0,
        ),
      ),
    );
}

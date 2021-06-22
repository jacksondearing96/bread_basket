import 'dart:async';

import 'package:bread_basket/providers/abbreviateDropdownProvider.dart';
import 'package:bread_basket/screens/workout/workoutSetType.dart';
import 'package:bread_basket/services/workoutSetType.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSetTypeDropdown extends StatefulWidget {
  int setNumber;
  WorkoutSetTypeDropdown({required this.setNumber});

  @override
  _WorkoutSetTypeDropdownState createState() => _WorkoutSetTypeDropdownState();
}

class _WorkoutSetTypeDropdownState extends State<WorkoutSetTypeDropdown> {


  String dropdownValue = Constants.normalCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.workoutSetTypeDropdownWidth,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              selectedItemBuilder: (context) {
                return _workoutSetTypes().map((workoutSetType) {
                  if (workoutSetType.code != Constants.warmUpCode) {
                    workoutSetType.setSetNumber(widget.setNumber);
                  }
                  workoutSetType.abbreviate();
                  return workoutSetType;
                }).toList();
              },
              items: _workoutSetTypes()
                  .map(_workoutSetTypeToDropdownMenuItem)
                  .toList(),
              onChanged: (newValue) =>
                  setState(() => dropdownValue = newValue ?? dropdownValue),
                  ),
        ),
      ),
    );
  }

  List<WorkoutSetType> _workoutSetTypes() {
    return [
      WorkoutSetType(
        name: 'Warm up',
        code: Constants.warmUpCode,
        color: Colors.yellow,
      ),
      WorkoutSetType(
        name: 'Drop set',
        code: Constants.dropSetCode,
        color: Colors.purple,
      ),
      WorkoutSetType(
        name: 'Failure',
        code: Constants.failureCode,
        color: Colors.red,
      ),
      WorkoutSetType(name: 'Normal', code: Constants.normalCode, color: Colors.black)
    ];
  }

  DropdownMenuItem<String> _workoutSetTypeToDropdownMenuItem(
      WorkoutSetType workoutSetType) {
    if (workoutSetType.code != Constants.warmUpCode) {
      workoutSetType.setSetNumber(widget.setNumber);
    }
    return DropdownMenuItem<String>(
        value: workoutSetType.code, child: workoutSetType);
  }
}

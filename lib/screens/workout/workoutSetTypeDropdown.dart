import 'dart:async';

import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/abbreviateDropdownProvider.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSetType.dart';
import 'package:bread_basket/services/workoutSetType.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSetTypeDropdown extends StatefulWidget {
  int setIndex;

  WorkoutSetTypeDropdown({required this.setIndex});

  @override
  _WorkoutSetTypeDropdownState createState() => _WorkoutSetTypeDropdownState();
}

class _WorkoutSetTypeDropdownState extends State<WorkoutSetTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PerformedExerciseProvider>(
        builder: (context, performedExerciseProvider, child) {
      PerformedSet set_ =
          performedExerciseProvider.exercise.sets[widget.setIndex];

      return Container(
        width: Constants.workoutSetTypeDropdownWidth,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: DropdownButton<String>(
                isExpanded: true,
                value: set_.setType,
                selectedItemBuilder: (context) {
                  return _workoutSetTypes().map((workoutSetType) {
                    workoutSetType.setSetNumber(widget.setIndex + 1);
                    workoutSetType.abbreviate();
                    return workoutSetType;
                  }).toList();
                },
                items: _workoutSetTypes()
                    .map(_workoutSetTypeToDropdownMenuItem)
                    .toList(),
                onChanged: (newValue) {
                  setState(() => set_.setType = newValue ?? set_.setType);
                  // performedExerciseProvider.updateSet(widget.setIndex, set_);
                }),
          ),
        ),
      );
    });
  }

  List<WorkoutSetType> _workoutSetTypes() {
    return [
      WorkoutSetType(
        name: 'Warm up',
        code: Constants.warmUpCode,
        color: Constants.warmUpSetTypeColor,
      ),
      WorkoutSetType(
        name: 'Drop set',
        code: Constants.dropSetCode,
        color: Constants.dropSetSetTypeColor,
      ),
      WorkoutSetType(
        name: 'Failure',
        code: Constants.failureCode,
        color: Constants.failureSetTypeColor,
      ),
      WorkoutSetType(
          name: 'Normal',
          code: Constants.normalCode,
          color: Constants.normalSetTypeColor)
    ];
  }

  DropdownMenuItem<String> _workoutSetTypeToDropdownMenuItem(
      WorkoutSetType workoutSetType) {
    workoutSetType.setSetNumber(widget.setIndex);
    return DropdownMenuItem<String>(
        value: workoutSetType.code, child: workoutSetType);
  }
}

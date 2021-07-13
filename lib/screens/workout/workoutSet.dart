import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSetTypeDropdown.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class WorkoutSet extends StatefulWidget {
  final int setIndex;
  final PerformedSet? prevSet;

  WorkoutSet({Key? key, required this.setIndex, this.prevSet})
      : super(key: key);

  @override
  _WorkoutSetState createState() => _WorkoutSetState();
}

class _WorkoutSetState extends State<WorkoutSet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode weightFocusNode = FocusNode();
  FocusNode repsFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
      PerformedSet performedSet =
          exerciseProvider.exercise.sets[widget.setIndex];

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ChangeNotifierProvider.value(
                  value: exerciseProvider,
                  child: WorkoutSetTypeDropdown(setIndex: widget.setIndex),
                ),
                Container(
                  width: Constants.prevSetWidth,
                  child: widget.prevSet == null
                      ? Container()
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(children: [
                            widget.prevSet!.styledTypeCode(),
                            Text(
                              '${widget.prevSet!.reps} x ${widget.prevSet!.getWeightString()}kg',
                              style: TextStyle(
                                  color: Constants.hintColor, fontSize: 14),
                            ),
                          ]),
                        ),
                ),
                Container(
                  width: Constants.workoutSetInputWidth,
                  child: TextFormField(
                      style: TextStyle(color: Constants.textColor),
                      focusNode: weightFocusNode,
                      initialValue: performedSet.weight == 0.0
                          ? ''
                          : performedSet.weight.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration:
                          Constants.setInputDecoration.copyWith(hintText: ''),
                      validator: _isValidWeight,
                      onChanged: (val) {
                        if (!_formIsValid()) return;
                        performedSet.weight = min(999, double.parse(val));
                      },
                      onEditingComplete: () {
                        if (!_formIsValid()) return;
                        setState(() {});
                        exerciseProvider.updateSet(
                            widget.setIndex, performedSet);
                      }),
                ),
                Container(
                  width: Constants.workoutSetInputWidth,
                  child: TextFormField(
                    style: TextStyle(color: Constants.textColor),
                    focusNode: repsFocusNode,
                    initialValue: performedSet.reps == 0
                        ? ''
                        : performedSet.reps.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration:
                        Constants.setInputDecoration.copyWith(hintText: ''),
                    validator: _isValidReps,
                    onChanged: (val) {
                      if (!_formIsValid()) return;
                      setState(
                          () => performedSet.reps = min(999, int.parse(val)));
                      updateSet(exerciseProvider.updateSet, performedSet);
                    },
                  ),
                ),
              ],
            )),
      );
    });
  }

  String? _isValidReps(String? val) {
    if (val == null || val.isEmpty) return null;
    return Util.isAValidInteger(val);
  }

  String? _isValidWeight(String? val) {
    if (val == null || val.isEmpty) return null;
    return Util.isAValidDouble(val);
  }

  bool _formIsValid() {
    FormState? state = _formKey.currentState;
    return state != null && state.validate();
  }

  void updateSet(Function providerUpdateSet, PerformedSet performedSet) {
    for (var focusNode in [weightFocusNode, repsFocusNode]) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          providerUpdateSet(widget.setIndex, performedSet);
        }
      });
    }
  }
}

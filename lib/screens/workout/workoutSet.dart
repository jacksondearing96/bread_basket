import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSetTypeDropdown.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSet extends StatefulWidget {
  int setIndex;
  PerformedSet? prevSet;

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
    return Consumer<PerformedExerciseProvider>(
        builder: (context, performedExerciseProvider, child) {
      performedExerciseProvider.exercise.log();
      PerformedSet performedSet =
          performedExerciseProvider.exercise.sets[widget.setIndex];

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ChangeNotifierProvider.value(
                  value: performedExerciseProvider,
                  child: WorkoutSetTypeDropdown(setIndex: widget.setIndex),
                ),
                Container(
                  width: Constants.prevSetWidth,
                  child: widget.prevSet == null
                      ? Container()
                      : Text(
                          '${widget.prevSet!.reps} x ${widget.prevSet!.getWeightString()}kg',
                          style: TextStyle(color: Constants.hintColor),
                        ),
                ),
                Container(
                  width: Constants.workoutSetInputWidth,
                  child: TextFormField(
                      focusNode: weightFocusNode,
                      initialValue: performedSet.weight == 0.0
                          ? ''
                          : performedSet.weight.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration:
                          Constants.setInputDecoration.copyWith(hintText: 'kg'),
                      validator: isAValidNumber,
                      onChanged: (val) =>
                          performedSet.weight = double.parse(val),
                      onEditingComplete: () {
                        setState(() {});
                        performedExerciseProvider.updateSet(
                            widget.setIndex, performedSet);
                      }),
                ),
                Container(
                  width: Constants.workoutSetInputWidth,
                  child: TextFormField(
                    focusNode: repsFocusNode,
                    initialValue: performedSet.reps == 0
                        ? ''
                        : performedSet.reps.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration:
                        Constants.setInputDecoration.copyWith(hintText: 'reps'),
                    validator: isAValidInteger,
                    onChanged: (val) {
                      setState(() => performedSet.reps = int.parse(val));
                      updateSet(
                          performedExerciseProvider.updateSet, performedSet);
                      // performedExerciseProvider.updateSet(
                      //     widget.setIndex, performedSet);
                    },
                  ),
                ),
              ],
            )),
      );
    });
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

  String? isAValidNumber(String? val) {
    return (val != null && double.tryParse(val) != null) ? null : 'invalid';
  }

  String? isAValidInteger(String? val) {
    return (val != null && int.tryParse(val) != null) ? null : 'invalid';
  }
}

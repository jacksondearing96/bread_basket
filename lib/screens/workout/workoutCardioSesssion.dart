import 'package:bread_basket/models/cardioSession.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSetTypeDropdown.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class WorkoutCardioSession extends StatefulWidget {
  final int setIndex;
  final CardioSession? prevSession;

  WorkoutCardioSession({Key? key, required this.setIndex, this.prevSession})
      : super(key: key);

  @override
  _WorkoutCardioSessionState createState() => _WorkoutCardioSessionState();
}

class _WorkoutCardioSessionState extends State<WorkoutCardioSession> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode durationFocusNode = FocusNode();
  FocusNode distanceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
      CardioSession session =
          exerciseProvider.exercise.cardioSessions[widget.setIndex];

      onTimeInputTap() {
        Picker(
          adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
            const NumberPickerColumn(
                begin: 0, end: 999, suffix: Text(' hours')),
            const NumberPickerColumn(
                begin: 0, end: 60, suffix: Text(' minutes'), jump: 15),
          ]),
          delimiter: <PickerDelimiter>[
            PickerDelimiter(
              child: Container(
                width: 30.0,
                alignment: Alignment.center,
                child: Icon(Icons.more_vert),
              ),
            )
          ],
          hideHeader: true,
          confirmText: 'OK',
          confirmTextStyle:
              TextStyle(inherit: false, color: Colors.red, fontSize: 22),
          title: const Text('Select duration'),
          selectedTextStyle: TextStyle(color: Colors.blue),
          onConfirm: (Picker picker, List<int> value) {
            // You get your duration here
            Duration _duration = Duration(
                hours: picker.getSelectedValues()[0],
                minutes: picker.getSelectedValues()[1]);
            setState(() => session.duration = _duration);
            updateSession(exerciseProvider.updateCardioSession, session);
          },
        ).showDialog(context);
      }

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
                  width: Constants.prevSessionWidth,
                  child: widget.prevSession == null
                      ? Container()
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(children: [
                            Text(
                              '${widget.prevSession!.getDistanceString()} - ${widget.prevSession!.getDurationString()}kg',
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
                      focusNode: durationFocusNode,
                      initialValue: session.distanceInMetres == 0.0
                          ? ''
                          : session.getDistanceString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration:
                          Constants.setInputDecoration.copyWith(hintText: ''),
                      validator: _isValidDistanceInKilometres,
                      onChanged: (val) {
                        if (!_formIsValid()) return;
                        session.distanceInMetres = min(999, double.parse(val));
                      },
                      onEditingComplete: () {
                        if (!_formIsValid()) return;
                        setState(() {});
                        exerciseProvider.updateCardioSession(
                            widget.setIndex, session);
                      }),
                ),
                GestureDetector(
                  onTap: onTimeInputTap(),
                  child: Container(
                    width: Constants.workoutSetInputWidth,
                    child: TextFormField(
                      style: TextStyle(color: Constants.textColor),
                      focusNode: distanceFocusNode,
                      initialValue: session.duration == Duration()
                          ? ''
                          : session.getDurationString(),
                      textAlign: TextAlign.center,
                      decoration:
                          Constants.setInputDecoration.copyWith(hintText: ''),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }

  String? _isValidDistanceInKilometres(String? val) {
    if (val == null || val.isEmpty) return null;
    return Util.isAValidDouble(val);
  }

  bool _formIsValid() {
    FormState? state = _formKey.currentState;
    return state != null && state.validate();
  }

  void updateSession(
      Function providerUpdateSession, CardioSession cardioSession) {
    for (var focusNode in [durationFocusNode, distanceFocusNode]) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          providerUpdateSession(widget.setIndex, cardioSession);
        }
      });
    }
  }
}

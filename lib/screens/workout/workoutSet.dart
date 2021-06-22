import 'package:bread_basket/screens/workout/workoutSetTypeDropdown.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class WorkoutSet extends StatefulWidget {
  WorkoutSet();

  int setNumber = -1;

  void setSetIndex(int index) {
    setNumber = index;
    print('Set number is: $setNumber');
  }

  @override
  _WorkoutSetState createState() => _WorkoutSetState();
}

class _WorkoutSetState extends State<WorkoutSet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double weight = 0.0;
  int reps = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              WorkoutSetTypeDropdown(setNumber: widget.setNumber),
              Container(
                width: Constants.workoutSetInputWidth,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration:
                      Constants.setInputDecoration.copyWith(hintText: 'kg'),
                  validator: isAValidNumber,
                  onChanged: (val) => setState(() => weight = double.parse(val)),
                ),
              ),
              Container(
                width: Constants.workoutSetInputWidth,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration:
                      Constants.setInputDecoration.copyWith(hintText: 'reps'),
                  validator: isAValidInteger,
                  onChanged: (val) => setState(() => reps = int.parse(val)),
                ),
              ),
            ],
          )),
    );
  }

  String? isAValidNumber(String? val) {
    return (val != null && double.tryParse(val) != null) ? null : 'invalid';
  }

  String? isAValidInteger(String? val) {
    return (val != null && int.tryParse(val) != null) ? null : 'invalid';
  }
}

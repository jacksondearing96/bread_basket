import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class WorkoutSetType extends StatefulWidget {
  final String name;
  final String code;
  final Color color;
  int setNumber = -1;
  bool _abbreviate = false;

  WorkoutSetType({
    required this.name,
    required this.code,
    required this.color,
  });

  void setSetNumber(int number) {
    setNumber = number;
  }

  void abbreviate() {
    _abbreviate = true;
  }

  @override
  _WorkoutSetTypeState createState() => _WorkoutSetTypeState();
}

class _WorkoutSetTypeState extends State<WorkoutSetType> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !widget._abbreviate
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                    widget.code == Constants.normalCode
                        ? widget.setNumber.toString()
                        : widget.code,
                    style: TextStyle(color: widget.color)),
              ),
        widget._abbreviate
            ? Container()
            : Text(widget.name, style: TextStyle(color: widget.color)),
      ],
    );
  }
}

import 'package:bread_basket/screens/workout/workoutSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bread_basket/models/performedExercise.dart';

class WorkoutExerciseTile extends StatefulWidget {
  final PerformedExercise exercise;
  bool isSelected;
  WorkoutExerciseTile({required this.exercise, required this.isSelected});

  @override
  _WorkoutExerciseTileState createState() => _WorkoutExerciseTileState();
}

class _WorkoutExerciseTileState extends State<WorkoutExerciseTile> {
  List<WorkoutSet> sets = [WorkoutSet()];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 6.0, 0, 0.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                radius: 25.0,
                backgroundColor:
                    widget.isSelected ? Constants.accentColor : Colors.grey),
            title: Text(widget.exercise.exercise.name),
            subtitle: Text('subtitle goes here'),
          ),
          _header(),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final thisSet = sets[index];
              sets[index].setSetIndex(index + 1);
              return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(getRandomString(10)),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() => sets.removeAt(index));
                  },
                  child: thisSet);
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _removeExerciseButton(),
                _addNewExerciseButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) {
        const _chars =
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        Random _rnd = Random();
        return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
      }));

  Row _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            width: Constants.workoutSetTypeDropdownWidth, child: Text('Set')),
        Container(width: Constants.workoutSetInputWidth, child: Text('Weight')),
        Container(
            width: Constants.workoutSetInputWidth,
            child: Text('Reps', textAlign: TextAlign.center)),
      ],
    );
  }

  FloatingActionButton _removeExerciseButton() {
    return FloatingActionButton(
      onPressed: () => _removeExercise(),
      tooltip: 'Remove exercise',
      child: Icon(Icons.close),
      mini: true,
      backgroundColor: Colors.red,
    );
  }

  FloatingActionButton _addNewExerciseButton() {
    return FloatingActionButton(
      onPressed: () => _addNewSet(),
      tooltip: 'Add set',
      child: Icon(Icons.add),
      mini: true,
    );
  }

  void _addNewSet() {
    print('Add another set');
    setState(() => sets.add(WorkoutSet()));
  }

  void _removeExercise() {}
}

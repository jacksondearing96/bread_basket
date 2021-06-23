import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:bread_basket/models/performedExercise.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseTile extends StatefulWidget {
  final int exerciseIndex;
  WorkoutExerciseTile({Key? key, required this.exerciseIndex}) : super(key: key);

  @override
  _WorkoutExerciseTileState createState() => _WorkoutExerciseTileState();
}

class _WorkoutExerciseTileState extends State<WorkoutExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PerformedExerciseProvider>(
        builder: (context, performedExerciseProvider, child) {
      String exerciseName = performedExerciseProvider.exercise.exercise.name;
      List<PerformedSet> sets = performedExerciseProvider.exercise.sets;

      return Card(
        margin: EdgeInsets.fromLTRB(0, 6.0, 0, 0.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  radius: 25.0, backgroundColor: Constants.accentColor),
              title: Text(exerciseName),
              subtitle: Text('subtitle goes here'),
            ),
            _header(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sets.length,
              itemBuilder: (context, index) {
                final thisSet = sets[index];
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
                    onDismissed: (direction) => 
                      performedExerciseProvider.removeSet(index)
                    ,
                    child: ChangeNotifierProvider.value(
                      value: performedExerciseProvider,
                      child: WorkoutSet(key: UniqueKey(), setIndex: index),
                    ));
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _removeExerciseButton(),
                  _addNewSetButton(performedExerciseProvider.addSet),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
      heroTag: UniqueKey(),
      onPressed: () => _removeExercise(),
      tooltip: 'Remove exercise',
      child: Icon(Icons.close),
      mini: true,
      backgroundColor: Colors.red,
    );
  }

  FloatingActionButton _addNewSetButton(Function addSet) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () => addSet(),
      tooltip: 'Add set',
      child: Icon(Icons.add),
      mini: true,
    );
  }

  void _removeExercise() {
    // Remove the entire exercise.
  }
}

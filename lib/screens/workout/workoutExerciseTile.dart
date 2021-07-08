import 'package:bread_basket/analytics/ExerciseProgressIndicator.dart';
import 'package:bread_basket/analytics/ProgressGraph.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutSet.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class WorkoutExerciseTile extends StatefulWidget {
  final int exerciseIndex;
  final Function removeExerciseCallback;

  WorkoutExerciseTile(
      {Key? key,
      required this.exerciseIndex,
      required this.removeExerciseCallback})
      : super(key: key);

  @override
  _WorkoutExerciseTileState createState() => _WorkoutExerciseTileState();
}

class _WorkoutExerciseTileState extends State<WorkoutExerciseTile> {
  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);

    return Consumer<PerformedExerciseProvider>(
        builder: (context, performedExerciseProvider, child) {
      Exercise exercise = performedExerciseProvider.exercise.exercise;
      List<PerformedSet> sets = performedExerciseProvider.exercise.sets;
      List<PerformedSet> mostRecentSetsOfExercise =
          history.mostRecentSetsOf(exerciseId: exercise.id);

      return Card(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  exercise.equipmentTypeIconLocation == ''
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(4.0),
                          height: 40,
                          width: 40,
                          child: Opacity(
                            opacity: Constants.equipmentTypeIconOpacity,
                            child: ImageIcon(
                              AssetImage(exercise.equipmentTypeIconLocation),
                              color: Constants.textColor,
                            ),
                          )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0, 5, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Constants.textColor,
                                    fontSize:
                                        Constants.selectExerciseFontSize)),
                            exercise.subtitle != ''
                                ? Text(exercise.subtitle,
                                    style:
                                        TextStyle(color: Constants.hintColor))
                                : Container(),
                          ]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    width: Constants.workoutExerciseImageWidth,
                    height: Constants.workoutExerciseImageHeight,
                    child: exercise.image,
                  ),
                  _removeExerciseButton(),
                ],
              ),
              ChangeNotifierProvider.value(
                value: performedExerciseProvider,
                child: ProgressGraph(exerciseId: exercise.id),
              ),
              SizedBox(height: 15),
              _header(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: sets.length,
                itemBuilder: (context, index) {
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
                          performedExerciseProvider.removeSet(index),
                      child: ChangeNotifierProvider.value(
                        value: performedExerciseProvider,
                        child: WorkoutSet(
                            key: UniqueKey(),
                            setIndex: index,
                            prevSet: mostRecentSetsOfExercise.length > index
                                ? mostRecentSetsOfExercise[index]
                                : null),
                      ));
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: ExerciseProgressIndicator(
                        exercise: performedExerciseProvider.exercise),
                  ),
                  _addNewSetButton(performedExerciseProvider.addSet),
                ],
              ),
            ],
          ),
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
            width: Constants.workoutSetTypeDropdownWidth, child: _text('Set')),
        Container(width: Constants.prevSetWidth, child: _text('Prev')),
        Container(
            width: Constants.workoutSetInputWidth, child: _text('Weight')),
        Container(width: Constants.workoutSetInputWidth, child: _text('Reps')),
      ],
    );
  }

  Text _text(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Constants.hintColor));
  }

  Widget _removeExerciseButton() {
    return GestureDetector(
      onTap: () => widget.removeExerciseCallback(widget.exerciseIndex),
      child: Icon(Icons.close, color: Colors.red),
    );
  }

  Widget _addNewSetButton(VoidCallback addSet) {
    return CustomFloatingActionButton(
        onPressed: addSet, iconData: Icons.add, tooltip: 'Add set', mini: true);
  }
}

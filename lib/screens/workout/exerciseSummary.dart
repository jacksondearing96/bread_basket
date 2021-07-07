import 'package:bread_basket/analytics/ExerciseProgressIndicator.dart';
import 'package:bread_basket/analytics/TinyExerciseProgressIndicator.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseSummary extends StatelessWidget {
  final PerformedExercise exercise;
  const ExerciseSummary({Key? key, required this.exercise}) : super(key: key);

  String setToString(PerformedSet set) {
    return '${set.reps} x ${set.getWeightString()}';
  }

  // TODO: Abstract this function as it is repeated in WorkoutExerciseTile.
  // TODO: Take into account the skip index 0 added in this version too.
  List<PerformedSet> _findMostRecentSetsOfExercise(
      List<PerformedWorkout>? prevWorkouts, Exercise exercise) {
    if (prevWorkouts == null) return [];

    bool isMostRecentExercise = true;
    for (PerformedWorkout prevWorkout in prevWorkouts.reversed.toList()) {
      // Want to skip the first item this time because the first item will
      // be the set that we just completed.
      if (isMostRecentExercise) {
        isMostRecentExercise = false;
        continue;
      }

      for (PerformedExercise prevExercise in prevWorkout.performedExercises) {
        if (prevExercise.exercise.id == exercise.id) {
          return prevExercise.sets;
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(children: [
                Row(children: [
                  Text('${exercise.sets.length} x '),
                  exercise.exercise.equipmentTypeIconLocation == ''
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(4.0),
                          height: 35,
                          width: 35,
                          child: Opacity(
                            opacity: Constants.equipmentTypeIconOpacity,
                            child: ImageIcon(
                              AssetImage(
                                  exercise.exercise.equipmentTypeIconLocation),
                              color: Constants.textColor,
                            ),
                          )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0, 5, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercise.exercise.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Constants.textColor,
                                    fontSize:
                                        Constants.selectExerciseFontSize)),
                            exercise.exercise.subtitle != ''
                                ? Text(exercise.exercise.subtitle,
                                    style:
                                        TextStyle(color: Constants.hintColor))
                                : Container(),
                          ]),
                    ),
                  ),
                ]),
              ]),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TinyExerciseProgressIndicator(
              prevSets: _findMostRecentSetsOfExercise(
                  pastWorkouts, exercise.exercise),
              currentSets: exercise.sets),
          Text('best: ${setToString(exercise.bestSet())}kg',
              style: TextStyle(fontSize: 14)),
        ]),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     Flexible(
        //       child: ExerciseProgressIndicator(
        //           prevSets: mostRecentSetsOfExercise, currentSets: sets),
        //     ),
        //     _addNewSetButton(performedExerciseProvider.addSet),
        //   ],
        // ),
      ],
    );
  }
}

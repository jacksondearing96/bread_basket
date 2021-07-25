import 'package:bread_basket/analytics/TinyExerciseProgressIndicator.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class ExerciseSummary extends StatelessWidget {
  final Exercise exercise;
  const ExerciseSummary({Key? key, required this.exercise}) : super(key: key);

  String setToString(PerformedSet set) {
    return '${set.reps} x ${set.getWeightString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(children: [
                Row(children: [
                  exercise.tags.contains('cardio')
                      ? Text('${exercise.cardioSessions.length} x ')
                      : Text('${exercise.sets.length} x '),
                  exercise.equipmentTypeIconLocation == ''
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(4.0),
                          height: 35,
                          width: 35,
                          child: Opacity(
                            opacity: Constants.equipmentTypeIconOpacity,
                            child: ImageIcon(
                              AssetImage(exercise.equipmentTypeIconLocation),
                              color: Constants.textColor,
                            ),
                          )),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                      child: Wrap(
                        children: [
                          Text(exercise.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Constants.textColor,
                                  fontSize: Constants.selectExerciseFontSize)),
                          exercise.subtitle != ''
                              ? Text('(${exercise.subtitle})',
                                  style: TextStyle(
                                      color: Constants.hintColor, fontSize: 14))
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ]),
              ]),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TinyExerciseProgressIndicator(exercise: exercise),
          exercise.sets.isEmpty
              ? Container()
              : Text('best: ${setToString(exercise.bestSet())}kg',
                  style: TextStyle(fontSize: 14)),
        ]),
        Divider(
          color: Constants.hintColor,
        ),
      ],
    );
  }
}

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/toolTipOnTap.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  final PerformedExercise exercise;
  ExerciseProgressIndicator({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);
    final prevSets = history.mostRecentSetsOf(
        exerciseId: exercise.exercise.id, skipFirstFound: true);

    return prevSets.isEmpty
        ? Container()
        : Container(
            height: 55.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _progressIndicatorTile(
                    Util.progressPercentage(
                        exercise, Util.bestWeight, prevSets),
                    Constants.weightIcon,
                    'Max weight (compared to last time)'),
                _progressIndicatorTile(
                    Util.progressPercentage(
                        exercise, Util.totalVolume, prevSets),
                    Constants.sigmaIcon,
                    'Total volume (compared to last time)'),
              ],
            ),
          );
  }

  Widget _progressIndicatorTile(
      int progress, String iconLocation, String tooltip) {
    bool improvement = progress >= 0;
    progress = progress.abs();
    return TooltipOnTap(
        message: tooltip,
        child: Container(
          margin: EdgeInsets.all(3.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: improvement
                ? Colors.green.withOpacity(0.25)
                : Colors.red.withOpacity(0.25),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: Constants.progressIndicatorIconWidth,
                height: Constants.progressIndicatorIconHeight,
                child: ImageIcon(
                  AssetImage(iconLocation),
                  color: Constants.textColor,
                ),
              ),
              Icon(improvement ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: improvement ? Colors.green : Colors.red),
              Text(
                "$progress%",
                style: TextStyle(color: Constants.hintColor),
              ),
            ],
          ),
        ));
  }
}

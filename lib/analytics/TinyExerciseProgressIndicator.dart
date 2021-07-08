import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/toolTipOnTap.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TinyExerciseProgressIndicator extends StatelessWidget {
  final Exercise exercise;
  TinyExerciseProgressIndicator({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);
    final prevSets = history.mostRecentSetsOf(
        exerciseId: exercise.exerciseId, skipFirstFound: true);

    return prevSets.isEmpty
        ? Container()
        : Container(
            height: 35.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tinyProgressIndicatorTile(
                    Util.progressPercentage(
                        exercise, Util.bestWeight, prevSets),
                    Constants.weightIcon,
                    'Max weight (compared to last time)'),
                _tinyProgressIndicatorTile(
                    Util.progressPercentage(
                        exercise, Util.totalVolume, prevSets),
                    Constants.sigmaIcon,
                    'Total volume (compared to last time)'),
              ],
            ),
          );
  }

  Widget _tinyProgressIndicatorTile(
      int progress, String iconLocation, String tooltip) {
    bool improvement = progress >= 0;
    progress = progress.abs();
    return TooltipOnTap(
        message: tooltip,
        child: Container(
          padding: EdgeInsets.all(4.0),
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
            ],
          ),
        ));
  }
}

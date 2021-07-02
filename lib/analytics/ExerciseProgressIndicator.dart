import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/toolTipOnTap.dart';
import 'package:flutter/material.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  final List<PerformedSet> prevSets;
  final List<PerformedSet> currentSets;
  ExerciseProgressIndicator(
      {required this.prevSets, required this.currentSets});

  double _totalVolume(List<PerformedSet> sets) {
    double totalVolume = 0;
    for (var s in sets) totalVolume += s.volume();
    return totalVolume;
  }

  double _bestWeight(List<PerformedSet> sets) {
    double bestWeight = 0;
    for (var s in sets)
      bestWeight = s.weight > bestWeight ? s.weight : bestWeight;
    return bestWeight;
  }

  int _progressPercentage(Function metric) {
    double prevMetric = metric(prevSets);
    if (prevMetric == 0) return 0;
    double progressRatio = metric(currentSets) / metric(prevSets);
    int rounded = ((progressRatio - 1) * 100).round();
    return rounded;
  }

  @override
  Widget build(BuildContext context) {
    return prevSets.isEmpty
        ? Container()
        : Container(
            height: 55.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _progressIndicatorTile(_progressPercentage(_bestWeight),
                    Constants.weightIcon, 'Max weight (compared to last time)'),
                _progressIndicatorTile(
                    _progressPercentage(_totalVolume),
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

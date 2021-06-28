import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  List<PerformedSet> prevSets;
  List<PerformedSet> currentSets;
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
    double progressRatio = metric(currentSets) / metric(prevSets);
    return ((progressRatio - 1) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _progressIndicatorTile(
              _progressPercentage(_bestWeight), Constants.weightIcon),
          _progressIndicatorTile(
              _progressPercentage(_totalVolume), Constants.sigmaIcon),
        ],
      ),
    );
  }

  Widget _progressIndicatorTile(int progress, Image icon) {
    bool improvement = progress >= 0;
    progress = progress.abs();
    return Container(
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
          SizedBox(
              width: Constants.progressIndicatorIconWidth,
              height: Constants.progressIndicatorIconHeight,
              child: icon),
          Icon(improvement ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: improvement ? Colors.green : Colors.red),
          Text(
            "$progress%",
            style: TextStyle(color: Constants.hintColor),
          ),
        ],
      ),
    );
  }
}
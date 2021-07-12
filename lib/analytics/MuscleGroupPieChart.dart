import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'PieChartPercentageIndicator.dart';

class MuscleGroupPieChart extends StatefulWidget {
  MuscleGroupPieChart({Key? key}) : super(key: key);

  @override
  _MuscleGroupPieChartState createState() => _MuscleGroupPieChartState();
}

class _MuscleGroupPieChartState extends State<MuscleGroupPieChart> {
  int touchedIndex = -1;
  Map<String, int> muscleGroupToExerciseCount = {};
  int totalExerciseCount = 0;

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);
    muscleGroupToExerciseCount = history.muscleGroupToExerciseCounts();
    totalExerciseCount = history.totalExerciseCount();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text('Muscle group relative distribution',
              style: TextStyle(color: Constants.hintColor)),
              SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: PieChart(
                      PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections()),
                    ),
                  ),
                ),
              ),
              Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getPieChartLabels(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> getPieChartLabels() {
    List<Widget> labels = [];
    List<Color> colors = []..addAll(Constants.pieChartColors);
    for (String muscleGroup in Constants.muscleGroups) {
      final exerciseCount = muscleGroupToExerciseCount.containsKey(muscleGroup)
          ? muscleGroupToExerciseCount[muscleGroup]!.toDouble()
          : 0.0;
      final proportionOfTotalExercises =
          (totalExerciseCount == 0) ? 0.0 : exerciseCount / totalExerciseCount;
      Color color = Colors.grey;
      if (exerciseCount > 0) {
        color = colors.removeAt(0);
      }
      labels.add(PieChartPercentageIndicator(
        color: color,
        text: muscleGroup,
        proportion: proportionOfTotalExercises,
        isSquare: false,
      ));
      labels.add(SizedBox(height: 6.0));
    }
    return labels;
  }

  List<PieChartSectionData> showingSections() {
    List<Color> colors = []..addAll(Constants.pieChartColors);
    return List.generate(Constants.muscleGroups.length, (i) {
      final muscleGroup = Constants.muscleGroups[i];
      final isTouched = i == touchedIndex;
      final exerciseCount = muscleGroupToExerciseCount.containsKey(muscleGroup)
          ? muscleGroupToExerciseCount[muscleGroup]!.toDouble()
          : 0.0;
      // final proportionOfTotalExercises =
      //     (totalExerciseCount == 0) ? 0.0 : exerciseCount / totalExerciseCount;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 80.0 : 60.0;
      Color color = Colors.grey;
      if (exerciseCount > 0) {
        color = colors.removeAt(0);
      }
      return PieChartSectionData(
        color: color,
        value: exerciseCount,
        title: muscleGroup,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}

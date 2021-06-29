import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'indicator.dart';

class MuscleGroupPieChart extends StatefulWidget {
  MuscleGroupPieChart({Key? key}) : super(key: key);

  @override
  _MuscleGroupPieChartState createState() => _MuscleGroupPieChartState();
}

class _MuscleGroupPieChartState extends State<MuscleGroupPieChart> {
  Map<String, int> muscleGroupToExerciseCount = {};
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    if (pastWorkouts != null) {
      for (PerformedWorkout workout in pastWorkouts) {
        for (PerformedExercise exercise in workout.performedExercises) {
          for (String muscleGroup in Constants.muscleGroups) {
            if (exercise.exercise.tags.contains(muscleGroup)) {
              muscleGroupToExerciseCount.update(
                muscleGroup,
                (existingValue) => existingValue + 1,
                ifAbsent: () => 1,
              );
            }
          }
        }
      }
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getPieChartLabels(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPieChartLabels() {
    List<Widget> labels = [];
    int index = 0;
    for (String muscleGroup in Constants.muscleGroups) {
      labels.add(Indicator(
          color: Constants.pieChartColors[index],
          text: muscleGroup,
          isSquare: true));
      labels.add(SizedBox(height: 4.0));
      ++index;
    }
    return labels;
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(Constants.muscleGroups.length, (i) {
      final muscleGroup = Constants.muscleGroups[i];
      print('Generating pie chart section data for muscle group: $muscleGroup');
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: Constants.pieChartColors[i],
        value: 
        muscleGroupToExerciseCount.containsKey(muscleGroup) ?
        muscleGroupToExerciseCount[muscleGroup]!.toDouble() : 0,
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

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressGraph extends StatelessWidget {
  final List<PerformedWorkout>? pastWorkouts;
  final String exerciseId;
  late final List<PerformedSet> bestSets;
  double bestPastWeight = 0;
  double worstPastWeight = 0;
  double verticalInterval = 0;
  ProgressGraph({required this.pastWorkouts, required this.exerciseId}) {
    bestSets = fetchBestPastSets();
    verticalInterval =
        ((bestPastWeight - worstPastWeight) / 4).round().toDouble();
  }

  List<PerformedSet> fetchBestPastSets() {
    List<PerformedSet> bestSetsList = [];
    if (pastWorkouts == null) return [];
    for (PerformedWorkout workout in pastWorkouts!) {
      for (PerformedExercise exercise in workout.performedExercises) {
        if (exercise.exercise.id != exerciseId) continue;
        PerformedSet? maxWeightSet;
        double maxWeight = 0;
        for (PerformedSet performedSet in exercise.sets) {
          // Update the local best weight for this workout.
          if (performedSet.weight > maxWeight) {
            maxWeightSet = performedSet;
            maxWeight = performedSet.weight;
          }

          // Update our overall best/worst weights.
          if (maxWeight > bestPastWeight) bestPastWeight = maxWeight;
          if (performedSet.weight < worstPastWeight)
            worstPastWeight = performedSet.weight;
        }
        if (maxWeightSet != null) bestSetsList.add(maxWeightSet);
      }
    }
    return bestSetsList;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return bestSets.length < 2
        ? Container()
        : Consumer<PerformedExerciseProvider>(
            builder: (context, performedExerciseProvider, child) {
            PerformedSet? bestCurrentSet = performedExerciseProvider.bestSet();
            if (bestCurrentSet != null) {
              bestSets.add(performedExerciseProvider.bestSet()!);
              if (bestCurrentSet.weight > bestPastWeight)
                bestPastWeight = bestCurrentSet.weight;
              if (bestCurrentSet.weight < worstPastWeight)
                worstPastWeight = bestCurrentSet.weight;
              verticalInterval =
                  ((bestPastWeight - worstPastWeight) / 4).round().toDouble();
            }
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 16),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((spotIndex) {
                            return TouchedSpotIndicatorData(
                              FlLine(color: Colors.blue, strokeWidth: 2),
                              FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                      strokeColor: Constants.accentColor);
                                },
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Constants.accentColor,
                            getTooltipItems:
                                (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final flSpot = barSpot;
                                return LineTooltipItem(
                                  '',
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: flSpot.y.toString(),
                                      style: TextStyle(
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' kg ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            }),
                      ),
                      minY: worstPastWeight,
                      maxY: bestPastWeight,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: verticalInterval,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(showTitles: false),
                        leftTitles: SideTitles(
                          interval: verticalInterval,
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                            color: Constants.hintColor,
                            fontSize: 11,
                          ),
                          getTitles: (value) =>
                              value.toString().replaceAll('.0', '') + 'kg',
                          reservedSize: 18,
                          margin: 12,
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1)),
                      lineBarsData: [
                        LineChartBarData(
                          spots: bestSets
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                  entry.key.toDouble(), entry.value.weight))
                              .toList(),
                          isCurved: true,
                          colors: gradientColors,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                    radius: 4.0,
                                    color:
                                        Constants.accentColor.withOpacity(0.6)),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.2))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          });
  }
}

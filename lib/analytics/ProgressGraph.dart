import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ProgressGraph extends StatefulWidget {
  final String exerciseId;

  ProgressGraph({required this.exerciseId});

  @override
  _ProgressGraphState createState() => _ProgressGraphState();
}

class _ProgressGraphState extends State<ProgressGraph> {
  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);

    List<PerformedSet> bestSets =
        history.bestSetFromEveryPastWorkout(exerciseId: widget.exerciseId);
    double bestPastWeight = Util.bestWeight(bestSets);
    double worstPastWeight = Util.worstWeight(bestSets);
    double verticalInterval =
        ((bestPastWeight - worstPastWeight) / 4).round().toDouble();
    if (verticalInterval == 0)
      verticalInterval = (bestPastWeight / 4).round().toDouble() + 1;
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    return bestSets.length < 2
        ? Container()
        : Consumer<ExerciseProvider>(
            builder: (context, exerciseProvider, child) {
            PerformedSet? bestCurrentSet = exerciseProvider.bestSet();
            if (bestCurrentSet != null) {
              bestSets.add(exerciseProvider.bestSet()!);
              if (bestCurrentSet.weight > bestPastWeight)
                bestPastWeight = bestCurrentSet.weight;
              if (bestCurrentSet.weight < worstPastWeight)
                worstPastWeight = bestCurrentSet.weight;
              verticalInterval =
                  ((bestPastWeight - worstPastWeight) / 4).round().toDouble();
              if (verticalInterval == 0)
                verticalInterval = (bestPastWeight / 4).round().toDouble() + 1;
            }
            return Container(
              height: 150,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Constants.progressGraphBackgroundColor),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((spotIndex) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                  color: Constants.primaryColor,
                                  strokeWidth: 2),
                              FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                      radius: 3,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                      strokeColor: Constants.primaryColor);
                                },
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Constants.primaryColor,
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
                      minY: max(worstPastWeight, 0),
                      maxY: max(bestPastWeight, worstPastWeight + 10),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: verticalInterval,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Constants.progressGraphGridLineColor,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Constants.progressGraphGridLineColor,
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
                            fontSize: 10,
                          ),
                          getTitles: (value) =>
                              value.toStringAsFixed(1).replaceAll('.0', '') +
                              'kg',
                          reservedSize: 18,
                          margin: 10,
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: Constants.progressGraphBorderColor,
                              width: 1)),
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

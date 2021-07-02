import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class WeeklyTrainingVolume extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WeeklyTrainingVolumeState();
}

class WeeklyTrainingVolumeState extends State<WeeklyTrainingVolume> {
  @override
  Widget build(BuildContext context) {
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    List<double> volumes = List.filled(7, 0.0);
    if (pastWorkouts != null) {
      for (PerformedWorkout workout in pastWorkouts.reversed) {
        DateTime now = DateTime.now();
        DateTime workoutTime =
            DateTime.fromMillisecondsSinceEpoch(workout.dateInMilliseconds);
        int difference = now.difference(workoutTime).inDays;
        if (difference >= 7) break;
        volumes[6 - difference] += workout.totalVolume();
      }
    }

    BarChartGroupData _barChartData(int dayOftheWeek, double volume) {
      return BarChartGroupData(x: dayOftheWeek, barRods: [
        BarChartRodData(
            y: volume, colors: [Constants.primaryColor, Constants.secondaryColor])
      ]);
    }

    List<BarChartGroupData> _generateBarChartData() {
      List<BarChartGroupData> list = [];
      int weekDay = 0;
      for (double volume in volumes) {
        list.add(_barChartData(weekDay, volume));
        ++weekDay;
      }
      return list;
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8), 
          color: 
          Colors.black.withAlpha(70)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [ 
              Text('Weekly training volumes (total kgs)',
              style: TextStyle(color: Constants.hintColor)), 
              SizedBox(height: 10),
              Expanded(
                child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: volumes.reduce(max),
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      tooltipMargin: 8,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          rod.y.round().toString(),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 20,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'M';
                          case 1:
                            return 'T';
                          case 2:
                            return 'W';
                          case 3:
                            return 'T';
                          case 4:
                            return 'F';
                          case 5:
                            return 'S';
                          case 6:
                            return 'S';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: _generateBarChartData(),
                ),
                            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

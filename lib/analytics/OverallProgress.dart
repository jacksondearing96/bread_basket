import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/toolTipOnTap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:intl/intl.dart';

class AxisLabelFrequencyController {
  int skipLimit = 0;
  int skipCounter = -1;
  String lastLabelSeen = '';
  int frequencyController = 4;

  init(int numberOfDataPoints) {
    skipCounter = -1;
    skipLimit = max(1, numberOfDataPoints / frequencyController).round();
  }

  bool isUnique(String label) {
    if (label == lastLabelSeen) return false;
    lastLabelSeen = label;
    return true;
  }

  bool shouldShowAxisLabel() {
    ++skipCounter;
    if (skipCounter > skipLimit) skipCounter = 0;
    return skipCounter == 0;
  }
}

class OverallProgress extends StatefulWidget {
  final AxisLabelFrequencyController axisLabelFrequencyController =
      AxisLabelFrequencyController();

  @override
  State<StatefulWidget> createState() => OverallProgressState();
}

class OverallProgressState extends State<OverallProgress> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);

    final overallWeightProgress = history.overallWeightProgress();
    List<double> weightProgress =
        overallWeightProgress.map((obj) => obj['data']!).toList();
    List<double> volumeProgress =
        history.overallVolumeProgress().map((obj) => obj['data']!).toList();
    List<double> timestamps =
        overallWeightProgress.map((obj) => obj['timestamp']!).toList();
    assert(weightProgress.length == volumeProgress.length);
    assert(weightProgress.length == timestamps.length);

    if (timestamps.isEmpty) return Container();

    widget.axisLabelFrequencyController.init(timestamps.length);

    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(children: [
        AspectRatio(
          aspectRatio: 1.23,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 37,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Overall progress estimate',
                        style: TextStyle(
                          color: Constants.hintColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 15),
                      TooltipOnTap(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        message:
                            "TL;DR - upwards trend = progress \n\nShows the trend in weight/volume of the best sets in each exercise of a workout with respect to a rolling average of your previous 5 workouts.",
                        child: Icon(Icons.info_outline_rounded,
                            color: Constants.hintColor, size: 18),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            legendEntry(
                                color: Constants.secondaryColor,
                                text: 'Max weight'),
                            SizedBox(height: 4),
                            legendEntry(
                                color: Constants.tertiaryColor,
                                text: 'Total volume'),
                          ]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                        child: LineChart(
                          sampleData1(
                              weightProgress, volumeProgress, timestamps),
                          swapAnimationDuration:
                              const Duration(milliseconds: 250),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  legendEntry({color: Color, text: Text}) {
    double size = 16;
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '$text',
          style: TextStyle(fontSize: 12, color: Constants.hintColor),
        )
      ],
    );
  }

  LineChartData sampleData1(List<double> weightProgress,
      List<double> volumeProgress, List<double> timestamps) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          getTextStyles: (value) => const TextStyle(
            color: Constants.hintColor,
            fontSize: 12,
          ),
          margin: 10,
          getTitles: (value) {
            if (widget.axisLabelFrequencyController.shouldShowAxisLabel()) {
              DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.round());
              final DateFormat format = DateFormat('MMM y');
              String label = format.format(date);
              return widget.axisLabelFrequencyController.isUnique(label)
                  ? label
                  : '';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          // getTextStyles: (value) => const TextStyle(
          //   color: Color(0xff75729e),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 14,
          // ),
          // getTitles: (value) {
          //   switch (value.toInt()) {
          //     case 1:
          //       return '1m';
          //     case 2:
          //       return '2m';
          //     case 3:
          //       return '3m';
          //     case 4:
          //       return '5m';
          //   }
          //   return '';
          // },
          // margin: 8,
          // reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Constants.hintColor,
            width: 1,
          ),
          left: BorderSide(
            color: Constants.hintColor,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: timestamps.reduce(min),
      maxX: timestamps.reduce(max),
      maxY: _maxY(weightProgress, volumeProgress),
      minY: _minY(weightProgress, volumeProgress),
      lineBarsData: linesBarData1(weightProgress, volumeProgress, timestamps),
    );
  }

  double _minY(List<double> weightProgress, List<double> volumeProgress) {
    double minY =
        [volumeProgress.reduce(min), weightProgress.reduce(min)].reduce(min);
    double buffer = 0.15;
    return minY - buffer * minY.abs();
  }

  double _maxY(List<double> weightProgress, List<double> volumeProgress) {
    double maxY =
        [volumeProgress.reduce(max), weightProgress.reduce(max)].reduce(max);
    double buffer = 0.15;
    return maxY + buffer * maxY.abs();
  }

  List<LineChartBarData> linesBarData1(List<double> weightProgress,
      List<double> volumeProgress, List<double> timestamps) {
    double barWidth = 5;
    final lineChartBarData1 = LineChartBarData(
      spots: weightProgress
          .asMap()
          .entries
          .map((entry) => FlSpot(timestamps[entry.key], entry.value))
          .toList(),
      isCurved: false,
      colors: [
        Constants.secondaryColor,
      ],
      barWidth: barWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: volumeProgress
          .asMap()
          .entries
          .map((entry) => FlSpot(timestamps[entry.key], entry.value))
          .toList(),
      isCurved: false,
      colors: [
        Constants.tertiaryColor,
      ],
      barWidth: barWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
        // getDotPainter: (spot, percent, barData, index) {
        //   return FlDotCirclePainter(
        //       radius: 3,
        //       color: Constants.primaryColor,
        //       strokeWidth: 1,
        //       strokeColor: Constants.primaryColor);
        // },
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }
}

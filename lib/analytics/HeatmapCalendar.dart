import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Week {
  List<Widget> days = [];

  void setDays(List<Widget> daysToSet) {
    days = daysToSet;
  }

  bool isFull() {
    return days.length == 7;
  }

  Widget draw() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: days,
    );
  }
}

class Calendar {
  List<Week> weeks = [];

  Calendar() {
    Week weekDayLabels = Week();
    weekDayLabels.setDays([
      weekDayLabel('M'),
      weekDayLabel('T'),
      weekDayLabel('w'),
      weekDayLabel('T'),
      weekDayLabel('F'),
      weekDayLabel('S'),
      weekDayLabel('S')
    ]);
    weeks.add(weekDayLabels);
  }

  void addDay(Widget day) {
    if (weeks.isEmpty || weeks.last.isFull()) weeks.add(Week());
    weeks.last.days.add(day);
  }

  Widget weekDayLabel(String weekday) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 2.1, 5, 2.1),
      child: Text(weekday,
          style: TextStyle(color: Constants.textColor, fontSize: 10)),
    );
  }

  Widget draw() {
    List<Widget> weeksRow = [];

    for (Week week in weeks) {
      weeksRow.add(week.draw());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: weeksRow,
    );
  }
}

class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({Key? key}) : super(key: key);

  String dateToStringKey(DateTime date) {
    return '${date.day.toString()}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    // Create a set of all the dates where a workout occurred.
    Map<String, int> workoutDates = {};
    if (pastWorkouts != null) {
      for (PerformedWorkout workout in pastWorkouts) {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(workout.dateInMilliseconds);
        print('w: ${dateToStringKey(date)}');
        workoutDates.update(dateToStringKey(date), (val) => val + 1,
            ifAbsent: () => 1);
      }
    }

    int daysToShow = 100 + DateTime.now().weekday - 2;
    Calendar calendar = Calendar();
    DateTime d = DateTime.now().subtract(Duration(days: daysToShow - 1));
    for (var i = 0; i < daysToShow; ++i) {
      print('d: ${dateToStringKey(d)}');
      calendar.addDay(_puck(workoutDates[dateToStringKey(d)] ?? 0));
      d = d.add(Duration(days: 1));
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(),
      child: calendar.draw(),
    );
  }

  Widget _puck(int intensity) {
    return Container(
      margin: EdgeInsets.all(1.5),
      width: 13.0,
      height: 13.0,
      decoration: BoxDecoration(
        color: _determinePuckColor(intensity),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Color _determinePuckColor(int intensity) {
    Color color = Colors.grey;
    switch (intensity) {
      case 1:
        color = Colors.green[300]!;
        break;
      case 2:
        color = Colors.green[500]!;
        break;
      case 3:
        color = Colors.green[700]!;
        break;
    }
    return color;
  }
}

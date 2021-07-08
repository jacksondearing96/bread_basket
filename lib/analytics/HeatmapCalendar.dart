import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/util.dart';
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
      child: Text(weekday, style: TextStyle(fontSize: 10)),
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



  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryService>(context);

    // Create a set of all the dates where a workout occurred.
    Map<String, int> workoutDates = history.workoutDates();

    int daysToShow = 100 + DateTime.now().weekday - 2;
    Calendar calendar = Calendar();
    DateTime d = DateTime.now().subtract(Duration(days: daysToShow - 1));
    for (var i = 0; i < daysToShow; ++i) {
      calendar.addDay(_puck(workoutDates[Util.dateToStringKey(d)] ?? 0));
      d = d.add(Duration(days: 1));
    }

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(70),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: _text(
              'Training frequency (last 100 days)',
            )),
        calendar.draw(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _text(
                'Less',
              ),
              SizedBox(width: 5),
              _puck(0),
              _puck(1),
              _puck(2),
              _puck(3),
              SizedBox(width: 5),
              _text('More'),
            ],
          ),
        ),
      ]),
    );
  }

  Text _text(String text) {
    return Text(text, style: TextStyle(color: Constants.hintColor));
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
    Color color;
    switch (intensity) {
      case 0:
        color = Color.fromARGB(255, 30, 30, 30);
        break;
      case 1:
        color = Colors.lightBlueAccent[100]!.withAlpha(200);
        break;
      case 2:
        color = Colors.lightBlueAccent[400]!;
        break;
      default:
        color = Colors.greenAccent[400]!;
    }
    return color;
  }
}

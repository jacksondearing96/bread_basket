import 'package:bread_basket/analytics/HeatmapCalendar.dart';
import 'package:bread_basket/analytics/MuscleGroupPieChart.dart';
import 'package:bread_basket/analytics/ProgressGraph.dart';
import 'package:bread_basket/analytics/WeeklyTrainingVolume.dart';
import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workout.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<List<Exercise>>(context);
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    Widget _button({text: String, icon: Icon, onTap: Function}) {
      return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.lightBlueAccent,
            Colors.greenAccent,
          ],
        )),
        child: ElevatedButton.icon(
          icon: Icon(
            icon,
            color: Constants.textColor,
          ),
          label: Text(
            text,
            style: TextStyle(color: Constants.textColor),
          ),
          onPressed: onTap,
          style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              primary: Constants.textColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: Constants.gradientAppBar(
        title: Text('Bread Basket'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.logout, color: Constants.textColor),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('logout'),
            style: TextButton.styleFrom(primary: Constants.textColor),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GradientButton(
                      text: 'New workout',
                      iconData: Icons.fitness_center,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Workout(exercises: exercises))),
                    ),
                    SizedBox(height: 15),
                    GradientButton(
                        text: 'History (coming soon)', iconData: Icons.history),
                  ],
                ),
              ),
              WeeklyTrainingVolume(),
              MuscleGroupPieChart(),
              HeatmapCalendar(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text('Bench Press',
                        style: TextStyle(color: Constants.hintColor)),
                    ChangeNotifierProvider.value(
                      value: PerformedExerciseProvider(
                          performedExercise: PerformedExercise(
                              exercise: Exercise(
                                  id: 35.toString(),
                                  name: 'bench_press_(barbell)',
                                  tags: []))),
                      child: ProgressGraph(exerciseId: 35.toString()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(children: [
                  Text('Deadlift',
                      style: TextStyle(color: Constants.hintColor)),
                  ChangeNotifierProvider.value(
                      value: PerformedExerciseProvider(
                          performedExercise: PerformedExercise(
                              exercise: Exercise(
                                  id: 1.toString(),
                                  name: 'deadlift_(barbell)',
                                  tags: []))),
                      child: ProgressGraph(exerciseId: 1.toString())),
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(children: [
                  Text('Squat', style: TextStyle(color: Constants.hintColor)),
                  ChangeNotifierProvider.value(
                      value: PerformedExerciseProvider(
                          performedExercise: PerformedExercise(
                              exercise: Exercise(
                                  id: 151.toString(),
                                  name: 'squat_(barbell)',
                                  tags: []))),
                      child: ProgressGraph(exerciseId: 151.toString())),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

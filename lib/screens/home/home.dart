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
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<List<Exercise>>(context);
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: Text('Bread Basket'),
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
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
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.fitness_center,
                        color: Constants.textColor,
                      ),
                      label: Text(
                        'New workout',
                        style: TextStyle(color: Constants.textColor),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Workout(exercises: exercises);
                        }));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Constants.accentColor,
                          primary: Constants.textColor),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.history,
                        color: Constants.textColor,
                      ),
                      label: Text(
                        'History (coming soon)',
                        style: TextStyle(color: Constants.textColor),
                      ),
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                          backgroundColor: Constants.accentColor,
                          primary: Constants.textColor),
                    ),
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
                  Text('Squat',
                      style: TextStyle(color: Constants.hintColor)),
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

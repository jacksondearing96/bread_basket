import 'package:bread_basket/analytics/HeatmapCalendar.dart';
import 'package:bread_basket/analytics/MuscleGroupPieChart.dart';
import 'package:bread_basket/analytics/ProgressGraph.dart';
import 'package:bread_basket/analytics/UserSnapshot.dart';
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
    final noWorkoutsYet = pastWorkouts == null || pastWorkouts.isEmpty;

    Widget _progressGraph({exerciseId: int}) {
      if (noWorkoutsYet || exercises.isEmpty) return Container();
      Exercise exercise =
          exercises.firstWhere((e) => e.id == exerciseId.toString());
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(exercise.title, style: TextStyle(color: Constants.hintColor)),
            ChangeNotifierProvider.value(
              value: PerformedExerciseProvider(
                  performedExercise: PerformedExercise(exercise: exercise)),
              child: ProgressGraph(exerciseId: exerciseId.toString()),
            ),
          ],
        ),
      );
    }

    void _startNewWorkout(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Workout(exercises: exercises)));
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: Constants.gradientAppBar(
        title: Text('GymStats'),
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
              UserSnapshot(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GradientButton(
                      text: 'New workout',
                      iconData: Icons.fitness_center,
                      onPressed: () => _startNewWorkout(context),
                    ),
                    SizedBox(height: 15),
                    GradientButton(
                        text: 'History (coming soon)',
                        iconData: Icons.history),
                  ],
                ),
              ),
              noWorkoutsYet ? Container() : WeeklyTrainingVolume(),
              noWorkoutsYet ? Container() : MuscleGroupPieChart(),
              HeatmapCalendar(),
              _progressGraph(exerciseId: Constants.benchPressExerciseId),
              _progressGraph(exerciseId: Constants.deadliftExerciseId),
              _progressGraph(exerciseId: Constants.squatExerciseId),
            ],
          ),
        ),
      ),
    );
  }
}

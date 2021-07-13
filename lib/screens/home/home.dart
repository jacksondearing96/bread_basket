import 'package:bread_basket/analytics/HeatmapCalendar.dart';
import 'package:bread_basket/analytics/MuscleGroupPieChart.dart';
import 'package:bread_basket/analytics/OverallProgress.dart';
import 'package:bread_basket/analytics/ProgressGraph.dart';
import 'package:bread_basket/analytics/UserSnapshot.dart';
import 'package:bread_basket/analytics/WeeklyTrainingVolume.dart';
import 'package:bread_basket/models/exerciseCatalog.dart';
import 'package:bread_basket/providers/exerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutScreen.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customButton.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final exerciseCatalog = Provider.of<ExerciseCatalog>(context);
    final history = Provider.of<HistoryService>(context);
    final noWorkoutsYet = history.workouts.isEmpty;

    Widget _progressGraph({exerciseId: int}) {
      if (noWorkoutsYet || exerciseCatalog.exercises.isEmpty)
        return Container();
      Exercise exercise = exerciseCatalog.exercises
          .firstWhere((e) => e.exerciseId == exerciseId.toString());
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ChangeNotifierProvider.value(
          value: ExerciseProvider(exerciseToProvide: exercise),
          child: ProgressGraph(
            exerciseId: exerciseId.toString(),
            showTitle: true,
          ),
        ),
      );
    }

    void _startNewWorkout(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkoutScreen(exercises: exerciseCatalog.exercises)));
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: Constants.gradientAppBar(
        title: Text('Monotonic'),
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
                    CustomButton(
                      text: 'New workout',
                      isLarge: true,
                      iconData: Icons.fitness_center,
                      onPressed: () => _startNewWorkout(context),
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                        text: 'History (coming soon)',
                        isLarge: true,
                        iconData: Icons.history),
                  ],
                ),
              ),
              noWorkoutsYet ? Container() : WeeklyTrainingVolume(),
              noWorkoutsYet ? Container() : OverallProgress(),
              SizedBox(height: 25),
              noWorkoutsYet ? Container() : MuscleGroupPieChart(),
              // noWorkoutsYet ? Container() : OverallProgress(),
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

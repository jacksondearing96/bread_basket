import 'dart:async';

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/providers/performedExercisesProvider.dart';
import 'package:bread_basket/screens/workout/selectExercise.dart';
import 'package:bread_basket/screens/workout/workoutExerciseList.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Workout extends StatefulWidget {
  final List<Exercise> exercises;
  Workout({required this.exercises});

  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = 'New Workout';
  PerformedExercisesProvider performedExercisesProvider =
      PerformedExercisesProvider();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        title: workoutTitleField(),
        actions: [
          TextButton(
            child: const Text('Finish'),
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              primary: Constants.textColor,
            ),
          ),
        ],
      ),
      body: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Exercises",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.textColor)),
                ChangeNotifierProvider(
                    create: (_) => performedExercisesProvider,
                    child: WorkoutExerciseList()),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      abandonButton(context),
                      completeButton(context),
                      addNewExerciseButton(context)
                    ]),
                  ),
                ),
              ])),
    );
  }

  TextFormField workoutTitleField() {
    return TextFormField(
      style: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.0),
      decoration: InputDecoration(
          hintStyle: TextStyle(color: Constants.textColor),
          hintText: workoutName,
          border: InputBorder.none),
      onChanged: (val) {
        setState(() => workoutName = val.trim());
      },
    );
  }

  FloatingActionButton addNewExerciseButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToSelectExercise(context),
      tooltip: 'New exercise',
      child: Icon(Icons.add),
    );
  }

  FloatingActionButton completeButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.check_outlined),
      tooltip: 'Complete',
      onPressed: () => completeWorkout(context),
      backgroundColor: Colors.green,
    );
  }

  FloatingActionButton abandonButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.close),
      tooltip: 'Abandon',
      onPressed: () => confirmAbandonment(context),
      backgroundColor: Colors.red,
    );
  }

  Future<String?> completeWorkout(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Complete workout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep working out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Complete', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<String?> confirmAbandonment(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Abandon workout?'),
        content: const Text("Don't quit now loser"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep working out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Abandon', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToSelectExercise(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SelectExercise(exercises: widget.exercises);
    }));

    if (result == null) return;
    _processSelectedExercises(result);
  }

  void _processSelectedExercises(List<Exercise> exercises) {
    for (Exercise exercise in exercises) {
      performedExercisesProvider
          .addExercise(PerformedExercise(exercise: exercise));
      exercise.log();
    }
  }
}

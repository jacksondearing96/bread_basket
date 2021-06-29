import 'dart:async';

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/screens/workout/selectExercise.dart';
import 'package:bread_basket/screens/workout/workoutExerciseList.dart';
import 'package:bread_basket/services/database.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Workout extends StatefulWidget {
  final List<Exercise> exercises;
  PerformedWorkout performedWorkout = PerformedWorkout();
  Workout({required this.exercises});

  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = 'New Workout';
  PerformedExerciseListProvider performedExerciseListProvider =
      new PerformedExerciseListProvider();

  bool isLoading = false;

  void startLoading() {
    print('Starting to load..');
    setState(() => isLoading = true);
  }

  void endLoading() {
    setState(() => isLoading = false);
  }

  void save(User? user) async {
    if (user != null) {
      startLoading();
      widget.performedWorkout.performedExercises = performedExerciseListProvider
          .exercises
          .map(
              (performedExerciseProvider) => performedExerciseProvider.exercise)
          .toList();
      if (widget.performedWorkout.performedExercises.isEmpty) {
        endLoading();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your workout is empty! Nothing to save.'),
        ));
        return;
      }
      await DatabaseService(userId: user.userId)
          .saveWorkout(widget.performedWorkout);
      Navigator.pop(context);
    }
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return isLoading
        ? Loading()
        : StreamProvider<List<PerformedWorkout>?>.value(
            initialData: [],
            value: DatabaseService(userId: user!.userId).pastWorkouts,
            child: Scaffold(
              backgroundColor: Constants.backgroundColor,
              appBar: AppBar(
                leading: TextButton(
                    child: Icon(Icons.delete, color: Constants.darkIconColor),
                    onPressed: () => confirmAbandonment(context)),
                backgroundColor: Constants.accentColor,
                elevation: 0.0,
                title: workoutTitleField(),
                actions: [
                  TextButton(
                    child: Icon(Icons.check_circle,
                        color: Constants.darkIconColor),
                    onPressed: () => completeWorkout(context, user, save),
                    style: TextButton.styleFrom(
                      primary: Constants.textColor,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ChangeNotifierProvider(
                            create: (_) => performedExerciseListProvider,
                            child: WorkoutExerciseList()),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: addNewExerciseButton(context),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
  }

  Widget workoutTitleField() {
    return TextFormField(
      style: TextStyle(
          color: Constants.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.0),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.create_rounded),
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
      heroTag: UniqueKey(),
      onPressed: () => _navigateToSelectExercise(context),
      tooltip: 'New exercise',
      child: Icon(Icons.add),
    );
  }

  Future<String?> completeWorkout(
      BuildContext context, User? user, Function save) {
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
            onPressed: () async {
              Navigator.pop(context);
              save(user);
            },
            child:
                const Text('Complete', style: TextStyle(color: Colors.green)),
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
      performedExerciseListProvider
          .addExercise(PerformedExercise(exercise: exercise));
      exercise.log();
    }
  }
}

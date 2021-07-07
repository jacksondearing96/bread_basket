import 'dart:async';

import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/screens/workout/selectExercise.dart';
import 'package:bread_basket/screens/workout/workoutExerciseList.dart';
import 'package:bread_basket/screens/workout/workoutSummary.dart';
import 'package:bread_basket/services/database.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/customFloatingActionButton.dart';
import 'package:bread_basket/shared/loading.dart';
import 'package:bread_basket/shared/gradientMask.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Workout extends StatefulWidget {
  final List<Exercise> exercises;
  final PerformedWorkout performedWorkout = PerformedWorkout();
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
    setState(() => isLoading = true);
  }

  void endLoading() {
    setState(() => isLoading = false);
  }

  void save(User? user) async {
    if (user == null) return;
    startLoading();
    widget.performedWorkout.performedExercises = performedExerciseListProvider
        .exercises
        .map((performedExerciseProvider) => performedExerciseProvider.exercise)
        .toList();
    if (widget.performedWorkout.performedExercises.isEmpty) {
      endLoading();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Your workout is empty! Nothing to save.'),
      ));
      return;
    }
    dynamic saveSuceeded = await DatabaseService(userId: user.userId)
        .saveWorkout(widget.performedWorkout);
    if (saveSuceeded) {
      Navigator.pop(context);
              WorkoutSummary(workout: widget.performedWorkout).show(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully saved workout.'),
      ));
    } else {
      endLoading();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save workout.'),
      ));
    }
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    DateTime selectedDate = DateTime.now();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now());
      if (pickedDate != null)
        setState(() {
          widget.performedWorkout.dateInMilliseconds =
              pickedDate.millisecondsSinceEpoch + (new Random()).nextInt(1000);
        });
    }

    Widget _datePicker() {
      return GestureDetector(
        onTap: () => _selectDate(context),
        child: Row(
          children: [
            GradientMask(
                child: Icon(Icons.calendar_today, color: Colors.white)),
            SizedBox(width: 20),
            Text(
                Constants.dateFormatter.format(new DateTime.fromMillisecondsSinceEpoch(
                        widget.performedWorkout.dateInMilliseconds)
                    .toLocal()),
                style: TextStyle(fontSize: 16.0, color: Constants.hintColor)),
          ],
        ),
      );
    }

    return isLoading
        ? Loading()
        : Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: Constants.gradientAppBar(
              leading: TextButton(
                  child: Icon(Icons.delete, color: Constants.darkIconColor),
                  onPressed: () => confirmAbandonment(context)),
              title: Text(workoutName),
              actions: [
                TextButton(
                  child: Row(children: [
                    Text('Finish', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Icon(Icons.check_circle, color: Constants.textColor),
                  ]),
                  onPressed: () => completeWorkout(context, user, save),
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
                      workoutTitleField(),
                      _datePicker(),
                      SizedBox(height: 20),
                      ChangeNotifierProvider(
                          create: (_) => performedExerciseListProvider,
                          child: WorkoutExerciseList()),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: addNewExerciseButton(context)),
                    ]),
              ),
            ),
          );
  }

  Widget workoutTitleField() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 200,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          GradientMask(child: Icon(Icons.create_rounded, color: Colors.white)),
          SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                color: Constants.hintColor,
              ),
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Constants.hintColor),
                  hintText: workoutName,
                  border: InputBorder.none),
              onChanged: (val) => workoutName = val.trim(),
              onEditingComplete: () => setState(() {}),
            ),
          ),
        ]),
      ),
    );
  }

  Widget addNewExerciseButton(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () => _navigateToSelectExercise(context),
      tooltip: 'New exercise',
      iconData: Icons.add,
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
      PerformedExercise performedExercise =
          PerformedExercise(exercise: exercise);
      // Start it off with 1 empty set.
      performedExercise.sets.add(PerformedSet());
      performedExerciseListProvider.addExercise(performedExercise);
    }
  }
}

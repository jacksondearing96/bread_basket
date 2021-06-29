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
import 'dart:math';
import 'package:intl/intl.dart';

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
    final DateFormat dateFormatter = DateFormat('EEEE d MMMM, y');

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
            Icon(Icons.calendar_today, color: Constants.accentColor),
            SizedBox(width: 20),
            Text(
                dateFormatter.format(new DateTime.fromMillisecondsSinceEpoch(
                        widget.performedWorkout.dateInMilliseconds)
                    .toLocal()),
                style: TextStyle(fontSize: 16.0, color: Constants.textColor)),
          ],
        ),
      );
    }

    return isLoading
        ? Loading()
        : Scaffold(
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
                  child: Icon(Icons.check_circle, color: Colors.white),
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
                      _datePicker(),
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
      backgroundColor: Constants.accentColor,
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

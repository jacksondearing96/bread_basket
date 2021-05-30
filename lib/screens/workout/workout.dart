import 'package:bread_basket/screens/workout/selectExercise.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';

class Workout extends StatefulWidget {
  final List<Exercise> exercises;
  Workout({required this.exercises});

  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  String workoutName = 'Workout';

  Widget build(BuildContext context) {
    print('Printing exercises');
    for (var exercise in widget.exercises) {
      print(exercise.name);
    }
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        title: Text(workoutName),
        actions: [
          TextButton(
            child: const Text('Finish'),
            onPressed: () {},
            style: TextButton.styleFrom(
              primary: Constants.textColor,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SelectExercise(exercises: widget.exercises);
          }));
        },
        tooltip: 'New exercise',
        child: Icon(Icons.add),
      ),
    );
  }
}

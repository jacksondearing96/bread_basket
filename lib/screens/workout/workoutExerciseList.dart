import 'package:bread_basket/models/exercise.dart';
import 'package:bread_basket/models/performedExercise.dart';
import 'package:bread_basket/models/performedSet.dart';
import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/providers/performedExerciseProvider.dart';
import 'package:bread_basket/screens/workout/workoutExerciseTile.dart';
import 'package:bread_basket/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutExerciseList extends StatefulWidget {
  WorkoutExerciseList();

  @override
  _WorkoutExerciseListState createState() => _WorkoutExerciseListState();
}

class _WorkoutExerciseListState extends State<WorkoutExerciseList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Consumer<PerformedExerciseListProvider>(
      builder: (context, performedExerciseListProvider, child) =>
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: performedExerciseListProvider.exercises.length,
              itemBuilder: (context, index) {
                return Container(
                    child: ChangeNotifierProvider.value(
                  value: performedExerciseListProvider.exercises[index],
                  child: WorkoutExerciseTile(
                    key: UniqueKey(),
                    exerciseIndex: index,
                    removeExerciseCallback:
                        performedExerciseListProvider.removeExercise,
                  ),
                ));
              }),
    );
  }
}

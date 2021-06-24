import 'package:bread_basket/providers/performedExerciseListProvider.dart';
import 'package:bread_basket/screens/workout/workoutExerciseTile.dart';
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
    return Consumer<PerformedExerciseListProvider>(
      builder: (context, performedExerciseListProvider, child) => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: performedExerciseListProvider.exercises.length,
          itemBuilder: (context, index) {
            return Container(
              child: ChangeNotifierProvider.value(
                value: performedExerciseListProvider.exercises[index],
                child: WorkoutExerciseTile(key: UniqueKey(),
                    exerciseIndex: index,
                    removeExerciseCallback: performedExerciseListProvider.removeExercise),
              ),
            );
          }),
    );
  }
}

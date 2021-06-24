import 'package:bread_basket/models/workout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bread_basket/models/exercise.dart';

class DatabaseService {
  final String? userId;
  DatabaseService({this.userId});

  final CollectionReference broCollection =
      FirebaseFirestore.instance.collection('bros');

  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercises');

  List<Exercise> _exerciseListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Exercise(id: doc.id, name: doc['name']))
        .toList();
  }

  // Get exercises stream.
  Stream<List<Exercise>> get exercises {
    return exerciseCollection.snapshots().map(_exerciseListFromQuerySnapshot);
  }

  void saveWorkout(PerformedWorkout workout) {
    workout.log('Saving workout:');

    for (var exercise in workout.performedExercises) {
      for (var set in exercise.sets) {
        print('attempting save of set');
        broCollection
            .doc(userId)
            .collection('workouts')
            .doc(workout.id)
            .collection('exercises')
            .doc(exercise.id)
            .collection('sets')
            .add({
          'type': set.setType,
          'weight': set.weight,
          'reps': set.reps
        }).then((value) => print('Saved set: ${value.id}'));
      }
    }
  }

  // Get exercise list for a workout.
  // Stream<List<Exercise>> getWorkout({ workoutId: workoutId }) {
  //   return broCollection
  //     .doc(userId)
  //     .collection('workouts')
  //     .doc(workoutId)
  // }
}

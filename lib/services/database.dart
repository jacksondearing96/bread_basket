import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bread_basket/models/exercise.dart';

class DatabaseService {
  final String? userId;
  DatabaseService({this.userId});

  final CollectionReference broCollection =
      FirebaseFirestore.instance.collection('bros');

  final CollectionReference exerciseCollection =
      FirebaseFirestore.instance.collection('exercises');

  Future<void> addSet({workoutId, exerciseId, setType, reps}) {
    return broCollection
        .doc(userId)
        .collection('workouts')
        .doc(workoutId)
        .collection('exercises')
        .doc(exerciseId)
        .collection('sets')
        .add({'type': setType, 'reps': reps});
  }

  List<Exercise> _exerciseListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Exercise(name: doc['name'])).toList();
  }

  // Get exercises stream.
  Stream<List<Exercise>> get exercises {
    return exerciseCollection.snapshots().map(_exerciseListFromQuerySnapshot);
  }
}

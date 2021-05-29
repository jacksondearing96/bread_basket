import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userId;
  DatabaseService({required this.userId});

  // Collection reference.
  final CollectionReference broCollection =
      FirebaseFirestore.instance.collection('bros');

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
}

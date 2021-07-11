import 'package:bread_basket/models/exercise.dart';

class ExerciseCatalog {
  late List<Exercise> _exercises;
  ExerciseCatalog(List<Exercise> exerciseList) {
    _exercises = exerciseList;
  }
  List<Exercise> get exercises => _exercises;
}

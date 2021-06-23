import 'package:bread_basket/shared/constants.dart';

class PerformedSet {
  String setType = Constants.normalCode;
  int reps = 0;
  double weight = 0.0;

  PerformedSet();

  void log() {
    print(
        "PERFORMED SET >> weight: $weight, reps: ${this.reps.toString()}, type: $setType");
  }
}

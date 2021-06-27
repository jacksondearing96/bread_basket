import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PerformedSet {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String setType = Constants.normalCode;
  int reps = 0;
  double weight = 0.0;

  PerformedSet();

  void log() {
    print(
        "PERFORMED SET >> weight: $weight, reps: ${this.reps.toString()}, type: $setType");
  }
}

import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PerformedSet {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String setType = Constants.normalCode;
  int reps = 0;
  double weight = 0.0;

  PerformedSet();

  static PerformedSet fromJson(Map<String, dynamic> json, String id) {
    print('Creating a PerformedSet from json, using: ');
    print(json);
    PerformedSet performedSet = PerformedSet();
    performedSet.id = id;
    performedSet.setType = json['type']!;
    performedSet.reps = json['reps']! as int;
    performedSet.weight = json['weight']! as double;
    return performedSet;
  }

  String getWeightString() {
    String str = weight.toString();
    str = str.replaceAll('.0', '');
    return str;
  }

  void log() {
    print(
        "PERFORMED SET >> weight: $weight, reps: ${this.reps.toString()}, type: $setType");
  }
}

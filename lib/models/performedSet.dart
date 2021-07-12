import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PerformedSet {
  String id = UniqueKey().toString();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String setType = Constants.normalCode;
  int reps;
  double weight;

  PerformedSet({this.weight = 0.0, this.reps = 0});

  bool equals(PerformedSet other) {
    return id == other.id &&
        timestamp == other.timestamp &&
        setType == other.setType &&
        reps == other.reps &&
        weight == other.weight;
  }

  static PerformedSet fromJson(Map<String, dynamic> json) {
    PerformedSet performedSet = PerformedSet();
    performedSet.id = json['id'];
    performedSet.setType = json['type']!;
    performedSet.reps = json['reps']! as int;
    performedSet.weight = json['weight']! as double;
    performedSet.timestamp = json['timestamp']! as int;
    return performedSet;
  }

  String getWeightString() {
    String str = weight.toStringAsFixed(2);
    str = str.replaceAll('.0', '');
    str = str.replaceAll('.0', '');
    return str;
  }

  double volume() {
    return reps * weight;
  }

  Map<String, Object> toJson() {
    return {
      'type': setType,
      'weight': weight,
      'reps': reps,
      'timestamp': timestamp,
      'id': id,
    };
  }

  Widget styledTypeCode() {
    if (setType == Constants.normalCode) return Container();

    Color color = Constants.failureSetTypeColor;
    if (setType == Constants.warmUpCode) {
      color = Constants.warmUpSetTypeColor;
    } else if (setType == Constants.dropSetCode) {
      color = Constants.dropSetSetTypeColor;
    }

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: Text(setType, style: TextStyle(color: color)));
  }

  void log() {
    print(
        "PERFORMED SET >> weight: $weight, reps: ${this.reps.toString()}, type: $setType");
  }
}

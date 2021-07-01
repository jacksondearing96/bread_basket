import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PerformedSet {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  String setType = Constants.normalCode;
  int reps = 0;
  double weight = 0.0;

  PerformedSet();

  static PerformedSet fromJson(Map<String, dynamic> json, String id) {
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

  double volume() {
    return reps * weight;
  }

  Widget styledTypeCode() {
    if (setType == Constants.normalCode) return Container();

    Color color = Constants.failureSetTypeColor;
    if (setType == Constants.warmUpCode) {
      color = Constants.warmUpSetTypeColor;
    } else if (setType == Constants.dropSetCode) {
      color = Constants.dropSetSetTypeColor;
    }

    return Container(padding: EdgeInsets.fromLTRB(0,0,5,0), child: Text(setType, style: TextStyle(color: color)));
  }

  void log() {
    print(
        "PERFORMED SET >> weight: $weight, reps: ${this.reps.toString()}, type: $setType");
  }
}

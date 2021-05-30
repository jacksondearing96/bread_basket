import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Constants.accentColor,
          ),
          title: Text(exercise.name),
          subtitle: Text('subtitle goes here'),
        ),
      ),
    );
  }
}

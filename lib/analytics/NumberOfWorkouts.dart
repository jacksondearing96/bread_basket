import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class NumberOfWorkouts extends StatelessWidget {
  final int numberOfWorkouts;
  const NumberOfWorkouts({Key? key, required this.numberOfWorkouts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.black.withAlpha(70),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: Constants.exerciseTypeIconWidth,
            width: Constants.exerciseTypeIconWidth,
            child: ImageIcon(
              AssetImage(Constants.equipmentTypeIcons['dumbbell']!),
              color: Constants.primaryColor.withAlpha(230),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
              child: Column(children: [
            Text(numberOfWorkouts.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white)),
            Text('Workouts',
                style: TextStyle(color: Constants.hintColor, fontSize: 12))
          ])),
        ],
      ),
    );
  }
}

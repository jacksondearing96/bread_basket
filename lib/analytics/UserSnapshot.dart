import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/models/workout.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/radiantGradientMask.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSnapshot extends StatelessWidget {
  const UserSnapshot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final pastWorkouts = Provider.of<List<PerformedWorkout>?>(context);

    double totalVolume = pastWorkouts == null
        ? 0
        : pastWorkouts.fold(
            0, (volume, workout) => volume + workout.totalVolume());

    return user == null
        ? Container()
        : Column(children: [
            Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(70),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      child: Text(user.name.isEmpty ? 'J' : user.name[0]),
                      radius: Constants.exerciseTypeIconWidth / 2,
                      backgroundColor: Constants.primaryColor),
                  SizedBox(width: 20),
                  Expanded(
                      child: Text(user.name,
                          style: TextStyle(fontSize: 18, color: Colors.white))),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
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
                            AssetImage(
                                Constants.equipmentTypeIcons['dumbbell']!),
                            color: Constants.primaryColor.withAlpha(230),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: Column(children: [
                          Text(
                              pastWorkouts == null
                                  ? '0'
                                  : pastWorkouts.length.toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text('Workouts',
                              style: TextStyle(
                                  color: Constants.hintColor, fontSize: 12))
                        ])),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
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
                            AssetImage(Constants.weightIcon),
                            color: Constants.primaryColor.withAlpha(230),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: Column(children: [
                          Text(totalVolume.round().toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          Text('kgs lifted',
                              style: TextStyle(
                                  color: Constants.hintColor, fontSize: 12))
                        ])),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]);
  }
}

import 'package:bread_basket/analytics/NumberOfWorkouts.dart';
import 'package:bread_basket/analytics/TotalWeightVolumeLifted.dart';
import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/services/database.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSnapshot extends StatelessWidget {
  const UserSnapshot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final history = Provider.of<HistoryService>(context);
    double totalVolume = history.totalVolume();

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
                  user.name.isEmpty
                      ? Container()
                      : CircleAvatar(
                          child: Text(user.name[0]),
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
                    child: GestureDetector(
                  onTap: () {
                    if (user.name == 'DemoName') {
                      DatabaseService(userId: user.userId)
                          .addDataToDemoAccount();
                    }
                  },
                  child: NumberOfWorkouts(
                    numberOfWorkouts: history.pastWorkouts.length,
                  ),
                )),
                Expanded(
                  child: TotalWeightVolumeLifted(kgs: totalVolume.round()),
                ),
              ],
            )
          ]);
  }
}

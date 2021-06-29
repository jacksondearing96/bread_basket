import 'package:bread_basket/analytics/MuscleGroupPieChart.dart';
import 'package:bread_basket/screens/workout/workout.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:bread_basket/models/exercise.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<List<Exercise>>(context);

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: Text('Bread Basket'),
        backgroundColor: Constants.accentColor,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.logout, color: Constants.textColor),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('logout'),
            style: TextButton.styleFrom(primary: Constants.textColor),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MuscleGroupPieChart(),
            Container(
              padding: EdgeInsets.fromLTRB(0, 120, 0, 50),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.fitness_center,
                      color: Constants.textColor,
                    ),
                    label: Text(
                      'New workout',
                      style: TextStyle(color: Constants.textColor),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Workout(exercises: exercises);
                      }));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Constants.accentColor,
                        primary: Constants.textColor),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.history,
                      color: Constants.textColor,
                    ),
                    label: Text(
                      'History (coming soon)',
                      style: TextStyle(color: Constants.textColor),
                    ),
                    onPressed: () => {},
                    style: TextButton.styleFrom(
                        backgroundColor: Constants.accentColor,
                        primary: Constants.textColor),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Constants.backgroundImage)),
          ],
        ),
      ),
    );
  }
}

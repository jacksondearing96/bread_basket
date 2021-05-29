import 'package:bread_basket/screens/workout/workout.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: Text('Bread Basket'),
          backgroundColor: Constants.accentColor,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                  Icons.person,
                  color: Constants.textColor),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Workout())
                );
              },
              style: TextButton.styleFrom(
                primary: Constants.textColor
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.history,
                  color: Constants.textColor,
                ),
                label: Text(
                  'History',
                  style: TextStyle(color: Constants.textColor),
                ),
                onPressed: () => {},
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.insights,
                  color: Constants.textColor,
                ),
                label: Text(
                  'Analytics',
                  style: TextStyle(color: Constants.textColor),
                ),
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

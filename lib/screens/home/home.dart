import 'package:bread_basket/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            title: Text('Bread Basket'),
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                icon: Icon(
                   Icons.person,
                   color: Colors.white),
                onPressed: () async {
                  await _auth.signOut();
                },
                label: Text('logout'),
                style: TextButton.styleFrom(
        primary: Colors.white,
      ),
              )
            ]),
      ),
    );
  }
}

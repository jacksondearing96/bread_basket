import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/screens/wrapper.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong with Firebase init.');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<User?>.value(
              initialData: null,
              value: AuthService().user,
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: MaterialApp(
                  theme: ThemeData(
                    accentColor: Constants.accentColor,

                  ),
                  home: Wrapper(),
                ),
              ),
            );
          }

          // Replace this with loading animation.
          return Text('Loading', textDirection: TextDirection.ltr);
        });
  }
}

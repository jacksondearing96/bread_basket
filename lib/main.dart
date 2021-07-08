import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/screens/wrapper.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:bread_basket/services/database.dart';
import 'package:bread_basket/services/history.dart';
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/loading.dart';
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
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Builder(builder: (context) {
                  final user = Provider.of<User?>(context);
                  return StreamProvider<HistoryService>.value(
                    initialData: HistoryService(pastWorkouts: []),
                    value: DatabaseService(
                            userId: user == null ? null : user.userId)
                        .history,
                    child: MaterialApp(
                      theme: ThemeData(
                        textTheme: TextTheme(
                          bodyText1: TextStyle(color: Constants.textColor),
                          bodyText2: TextStyle(color: Constants.hintColor),
                          subtitle1: TextStyle(color: Constants.hintColor),
                          subtitle2: TextStyle(color: Constants.hintColor),
                          button: TextStyle(color: Constants.hintColor),
                          caption: TextStyle(color: Constants.hintColor),
                        ),
                      ),
                      home: Wrapper(),
                    ),
                  );
                }),
              ),
            );
          }

          // Replace this with loading animation.
          return Loading();
        });
  }
}

import 'package:bread_basket/screens/authenticate/register.dart';
import 'package:bread_basket/screens/authenticate/signIn.dart';
import 'package:bread_basket/services/auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthService authService = AuthService();

  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toggleView: toggleView, authService: authService)
        : Register(toggleView: toggleView, authService: authService);
  }
}

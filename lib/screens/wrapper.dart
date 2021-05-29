import 'package:bread_basket/models/user.dart';
import 'package:bread_basket/screens/authenticate/authenticate.dart';
import 'package:bread_basket/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the user from the provider stream that we wrapped
    // this class in (inside main.dart).
    final user = Provider.of<User?>(context);

    return user == null ? Authenticate() : Home();
  }
}

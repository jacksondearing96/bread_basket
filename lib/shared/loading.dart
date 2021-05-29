import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.backgroundColor,
      child: Center(
              child: SpinKitRotatingCircle(
          color: Constants.accentColor,
          size: 50.0,
        ),
      ),
    );
  }
}
import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/radiantGradientMask.dart';
import 'package:flutter/material.dart';

class GradientFloatingActionButton extends StatelessWidget {
  VoidCallback onPressed;
  IconData iconData;
  String tooltip;

  GradientFloatingActionButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      required this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadiantGradientMask(
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(iconData, color: Constants.darkIconColor),
        backgroundColor: Constants.floatingActionButtonColor,
      ),
    );
  }
}

import 'package:bread_basket/shared/constants.dart';
import 'package:bread_basket/shared/gradientMask.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final String tooltip;
  final bool mini;

  CustomFloatingActionButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      required this.tooltip,
      this.mini = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientMask(
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(iconData, color: Constants.darkIconColor),
        backgroundColor: Constants.floatingActionButtonColor,
        mini: mini
      ),
    );
  }
}

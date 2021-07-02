import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  final Color? overrideColor;
  final Widget? child;

  RadiantGradientMask({this.child, this.overrideColor});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          overrideColor ?? Constants.secondaryColor,
          overrideColor ?? Constants.primaryColor
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}

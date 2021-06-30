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
          overrideColor ?? Colors.greenAccent,
          overrideColor ?? Colors.lightBlueAccent
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}

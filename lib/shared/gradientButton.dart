import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  late final Gradient gradient;
  final double width;
  final double height;
  final IconData? iconData;
  final VoidCallback? onPressed;

  final color = Constants.textColor;

  GradientButton({
    required this.text,
    this.width = double.infinity,
    this.height = 50.0,
    this.iconData,
    this.onPressed,
  }) {
    this.gradient = LinearGradient(
      colors: <Color>[Colors.lightBlueAccent, Colors.greenAccent],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 60.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]!,
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed ?? (() {}),
            child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                iconData == null
                    ? Container()
                    : Icon(iconData, color: color),
                SizedBox(width: 10),
                Text(text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color))
              ]),
            )),
      ),
    );
  }
}

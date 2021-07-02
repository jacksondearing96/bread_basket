import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class PieChartPercentageIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final double proportion;

  const PieChartPercentageIndicator({
    Key? key,
    required this.color,
    required this.text,
    required this.proportion,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '$text ${(proportion * 100).toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 12, color: Constants.hintColor),
        )
      ],
    );
  }
}

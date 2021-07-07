import 'package:bread_basket/shared/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  late final Gradient gradient;
  final double width;
  final double height;
  final IconData? iconData;
  final String? imageIconLocation;
  final Function? onPressed;
  final bool isLarge;

  final color = Constants.textColor;

  CustomButton({
    required this.text,
    Key? key,
    this.width = double.infinity,
    this.height = 50.0,
    this.iconData,
    this.imageIconLocation,
    this.onPressed,
    this.isLarge = false,
  }) : super(key: key) {
    this.gradient = Constants.themeGradient;
  }

  Widget _normalContainer({decoration: BoxDecoration, child: Widget}) {
    return Container(decoration: decoration, child: child);
  }

  Widget _largeContainer({decoration: BoxDecoration, child: Widget}) {
    return Container(
        width: 220, height: 60, decoration: decoration, child: child);
  }

  @override
  Widget build(BuildContext context) {
    Function _container = isLarge ? _largeContainer : _normalContainer;
    return _container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(170),
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              if (onPressed != null) onPressed!();
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconData == null ? Container() : Icon(iconData, color: color),
                  imageIconLocation == null
                      ? Container()
                      : ImageIcon(AssetImage(imageIconLocation!), color: color),
                  SizedBox(width: 10),
                  Text(text,
                      style:
                          TextStyle(
                            fontWeight: FontWeight.bold, color: color))
                ]),
              ),
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TooltipOnTap extends StatelessWidget {
  final Widget child;
  final String message;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  TooltipOnTap(
      {required this.message, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      padding: padding,
      margin: margin,
      key: key,
      message: message,
      showDuration: Duration(seconds: 3),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}

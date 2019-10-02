import 'package:flutter/material.dart';

class DefaultPadding extends StatelessWidget {
  /// Value = 20
  static const double horizontal = 20;

  /// Value = 10
  static const double vertical = 10;

  final Widget child;
  final bool noHorizontal;
  final bool noVertical;

  DefaultPadding({
    @required this.child,
    this.noHorizontal = false,
    this.noVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final double hor = noHorizontal ? 0 : horizontal;
    final double ver = noVertical ? 0 : vertical;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hor, vertical: ver),
      child: child,
    );
  }
}


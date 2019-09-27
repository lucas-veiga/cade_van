import 'package:flutter/material.dart';

class DefaultPadding extends StatelessWidget {
  /// Value = 20
  static const double horizontal = 20;

  /// Value = 10
  static const double vertical = 10;

  final Widget child;

  DefaultPadding({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }
}


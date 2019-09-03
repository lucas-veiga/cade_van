import 'package:flutter/material.dart';

import '../utils/default_padding.dart';

class CustomDivider extends StatelessWidget {
  final double height;
  final double endIndent;
  final double indent;

  CustomDivider({
    this.indent = DefaultPadding.horizontal,
    this.endIndent = DefaultPadding.horizontal,
    this.height = DefaultPadding.vertical,
  });

  @override
  Divider build(BuildContext context) =>
      Divider(
        color: Theme.of(context).primaryColor,
        height: height,
        endIndent: endIndent,
        indent: indent,
      );
}

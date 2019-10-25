import 'package:flutter/material.dart';

import '../utils/application_color.dart';

class Toast {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final String msg,
    final BuildContext context,
    {
      final ApplicationColorEnum backgroundColor = ApplicationColorEnum.ERROR,
      final Color backgroundColorCustom,
      final int durationMilliseconds = 2,
    }) {

    return Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: durationMilliseconds),
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        backgroundColor: _getBGColor(backgroundColor, backgroundColorCustom),
      ),
    );
  }

  Color _getBGColor(final ApplicationColorEnum colorEnum, final Color customColor) {
    if (customColor != null) {
      return customColor;
    }

    return ApplicationColor.decodeEnum(colorEnum);
  }
}

import 'package:flutter/material.dart';

import '../utils/application_color.dart';

class Toast {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    final String msg,
    final BuildContext context,
    { ApplicationColorEnum backgroundColor = ApplicationColorEnum.ERROR }) {

    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        backgroundColor: ApplicationColor.decodeEnum(backgroundColor),
      ),
    );
  }
}

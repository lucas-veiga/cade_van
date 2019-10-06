import 'package:flutter/material.dart';

import './utils_exception.dart';

class ApplicationColor {
  static const Color MAIN     = Colors.indigo;

  static const Color ERROR    = Colors.red;
  static const Color SUCCESS  = Colors.green;
  static const Color WARNING  = Colors.orange;

  static Color decodeEnum(final ApplicationColorEnum value) {
    switch (value) {
      case ApplicationColorEnum.MAIN:
        return ApplicationColor.MAIN;
      case ApplicationColorEnum.ERROR:
        return ApplicationColor.ERROR;
      case ApplicationColorEnum.SUCCESS:
        return ApplicationColor.SUCCESS;
      case ApplicationColorEnum.WARNING:
        return ApplicationColor.WARNING;
      default:
        throw UtilException('Nenhuma cor encontrada para $value');
    }
  }
}

enum ApplicationColorEnum {
  MAIN,
  ERROR,
  SUCCESS,
  WARNING,
}

import 'package:flutter/material.dart';

enum ChildStatusEnum {
  DEIXADO_ESCOLA,
  TRANSITO_ESCOLA,
  DEIXADO_CASA,
  TRANSITO_CASA,
}

class DecodeChileStatusEnum {
  static String getText(ChildStatusEnum value) {
    if (value == ChildStatusEnum.DEIXADO_ESCOLA) {
      return 'Deixado na Escola';
    }

    if (value == ChildStatusEnum.TRANSITO_ESCOLA) {
      return 'Em transito para escola';
    }

    if (value == ChildStatusEnum.DEIXADO_CASA) {
      return 'Em casa';
    }

    return 'Em transito para casa';
  }

  static Color getColor(ChildStatusEnum value) {
    if (value == ChildStatusEnum.DEIXADO_ESCOLA) {
      return Colors.green;
    }

    if (value == ChildStatusEnum.TRANSITO_ESCOLA) {
      return Colors.blue;
    }

    if (value == ChildStatusEnum.DEIXADO_CASA) {
      return Colors.tealAccent;
    }

    return Colors.yellow;
  }
}

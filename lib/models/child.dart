import 'package:flutter/material.dart';

class Child {
  int id;
  String name;
  String school;
  DateTime birthDate;
  String period;
  int responsibleId;
  String driverCode;
  int driverId;

  Child({
    @required this.id,
    @required this.name,
    @required this.school,
    @required this.birthDate,
    @required this.period,
    @required this.responsibleId,
    @required this.driverCode,
    @required this.driverId
  });

  Child.empty();

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer();
    buffer.write('Child: ');
    buffer.write('{ ');
    buffer.write('id: $id, ');
    buffer.write('name: "$name", ');
    buffer.write('school: "$school", ');
    buffer.write('dateBirth: "${birthDate.toString()}", ');
    buffer.write('period: "$period", ');
    buffer.write('responsibleId: $responsibleId, ');
    buffer.write('driverCode: "$driverCode", ');
    buffer.write('driverId: $driverId, ');
    return buffer.toString();
  }
}

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

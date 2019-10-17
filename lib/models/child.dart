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

  Child.empty();

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

  Child.copy(final Child child):
      id = child.id,
      name = child.name,
      school = child.school,
      birthDate = child.birthDate,
      period = child.period,
      responsibleId = child.responsibleId,
      driverCode = child.driverCode,
      driverId = child.driverId;

  Child.fromJSON(final dynamic json):
      id = json['id'],
      name = json['name'],
      school = json['school'],
      birthDate = DateTime.parse(json['birthDate']),
      period = json['period'],
      responsibleId = json['responsibleId'],
      driverCode = json['driverCode'],
      driverId = json['driverId'];

  static Map<String, dynamic> toJSON(final Child child) =>
    {
      'id': child.id,
      'name': child.name,
      'school': child.school,
      'birthDate': child.birthDate.toIso8601String(),
      'period': child.period,
      'responsibleId': child.responsibleId,
      'driverCode': child.driverCode,
    };

  @override
  int get hashCode =>
    id.hashCode^
    name.hashCode^
    school.hashCode^
    birthDate.hashCode^
    period.hashCode^
    responsibleId.hashCode^
    driverCode.hashCode;

  @override
  bool operator ==(other) =>
    other is Child && (
      id == other.id &&
        name == other.name &&
        school == other.school &&
        birthDate == other.birthDate &&
        period == other.period &&
        responsibleId == other.responsibleId &&
        driverCode == other.driverCode
    );

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
    buffer.write('driverId: $driverId ');
    buffer.write('}');
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

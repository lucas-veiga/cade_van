import 'package:flutter/material.dart';

import './model_exception.dart';

class Child {
  int id;
  String name;
  String school;
  DateTime birthDate;
  String period;
  ChildStatusEnum status;
  int responsibleId;
  int driverId;
  String driverCode;

  Child.empty();

  Child({
    @required this.id,
    @required this.name,
    @required this.school,
    @required this.birthDate,
    @required this.period,
    @required this.status,
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
      status = child.status,
      responsibleId = child.responsibleId,
      driverCode = child.driverCode,
      driverId = child.driverId;

  Child.fromJSON(final dynamic json):
      id = json['id'],
      name = json['name'],
      school = json['school'],
      birthDate = DateTime.parse(json['birthDate']),
      period = json['period'],
      status = _statusFromJSON(json['status']),
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
      'status': _statusToJSON(child.status),
      'responsibleId': child.responsibleId,
      'driverCode': child.driverCode,
    };

  static ChildStatusEnum _statusFromJSON(final String status) {
    switch (status.trim().toUpperCase()) {
      case 'WAITING':
        return ChildStatusEnum.WAITING;
      case 'GOING_SCHOOL':
        return ChildStatusEnum.GOING_SCHOOL;
      case 'GOING_HOME':
        return ChildStatusEnum.GOING_HOME;
      case 'LEFT_SCHOOL':
        return ChildStatusEnum.LEFT_SCHOOL;
      case 'LEFT_HOME':
        return ChildStatusEnum.LEFT_HOME;
      default:
        throw ModelException('ChildStatusEnum nao encontrado | _statusFromJSON: $status');
    }
  }

  static String _statusToJSON(final ChildStatusEnum status) {
   switch (status) {
     case ChildStatusEnum.WAITING:
       return 'WAITING';
     case ChildStatusEnum.GOING_SCHOOL:
       return 'GOING_SCHOOL';
     case ChildStatusEnum.GOING_HOME:
       return 'GOING_HOME';
     case ChildStatusEnum.LEFT_SCHOOL:
       return 'LEFT_SCHOOL';
     case ChildStatusEnum.LEFT_HOME:
       return 'LEFT_HOME';
     default:
        throw ModelException('ChildStatusEnum nao encontrado | _statusToJSON: $status');
   }
  }

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
    buffer.write('status: "$status", ');
    buffer.write('responsibleId: $responsibleId, ');
    buffer.write('driverCode: "$driverCode", ');
    buffer.write('driverId: $driverId ');
    buffer.write('}');
    return buffer.toString();
  }
}

enum ChildStatusEnum {
  WAITING,
  GOING_SCHOOL,
  GOING_HOME,
  LEFT_SCHOOL,
  LEFT_HOME,
}

class DecodeChileStatusEnum {
  static String getDescription(ChildStatusEnum value) {
    switch (value) {
      case ChildStatusEnum.LEFT_SCHOOL:
        return 'Deixado na Escola';
      case ChildStatusEnum.LEFT_HOME:
        return 'Deixado em Casa';
      case ChildStatusEnum.GOING_SCHOOL:
        return 'Indo para Escola';
      case ChildStatusEnum.GOING_HOME:
        return 'Indo para Casa';
      case ChildStatusEnum.WAITING:
        return 'Esperando Motorista';
      default:
        throw ModelException('ChildStatusEnum nao encontrado | getDescription: $value');
    }
  }

  static Color getColor(ChildStatusEnum value) {
    switch (value) {
      case ChildStatusEnum.LEFT_SCHOOL:
        return Colors.blue;
      case ChildStatusEnum.LEFT_HOME:
        return Colors.purple;
      case ChildStatusEnum.GOING_SCHOOL:
        return Colors.blue;
      case ChildStatusEnum.GOING_HOME:
        return Colors.purple;
      case ChildStatusEnum.WAITING:
        return Colors.green;
      default:
        throw ModelException('ChildStatusEnum nao encontrado | getColor: $value');
    }
  }
}

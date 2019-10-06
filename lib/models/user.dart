import 'package:location/location.dart';

import 'package:meta/meta.dart';

enum UserTypeEnum { DRIVER, RESPONSIBLE }

class User {
  int id;
  String email;
  String password;
  String name;
  String phone;
  String cpf;
  String nickname;
  UserTypeEnum type;
  LocationData userLocation;

  User({
    @required this.id,
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.phone,
    @required this.cpf,
    @required this.nickname,
    @required this.type,
    @required this.userLocation,
  });

  User.empty();

  User.copy(final User user):
      id = user.id,
      email = user.email,
      password = user.password,
      name = user.name,
      phone = user.phone,
      cpf = user.cpf,
      nickname = user.nickname,
      type = user.type,
      userLocation = user.userLocation;


  User.fromJSON(final dynamic json, final UserTypeEnum type):
      this.id = json['id'],
      this.email = json['email'],
      this.phone = json['phone'],
      this.name = json['name'],
      this.type = type;

  static Map<String, dynamic> toJSON(User user) =>
    {
      'id': user.id,
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'phone': user.phone,
      'cpf': user.cpf,
      'nickname': user.nickname,
      'type': _getType(user.type),
    };

  static String _getType(final UserTypeEnum type) {
    if (type == null) {
      return null;
    }

    if (type == UserTypeEnum.DRIVER) {
      return 'driver';
    }
    return 'responsible';
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('User: ');
    buffer.write('{ ');
    buffer.write('id: $id, ');
    buffer.write('email: "$email", ');
    buffer.write('password: "$password", ');
    buffer.write('name: "$name", ');
    buffer.write('phone: "$phone", ');
    buffer.write('cpf: "$cpf", ');
    buffer.write('nickname: "$nickname", ');
    buffer.write('type: "$type", ');
    buffer.write('location: { ');
    buffer.write('latitude: $_latitude, ');
    buffer.write('longitude: $_longitude ');
    buffer.write('}');
    buffer.write(' }');
    return buffer.toString();
  }

  double get _latitude {
    if (userLocation == null) return null;
    if (userLocation.latitude == null) return null;
    return userLocation.latitude;
  }

  double get _longitude {
    if (userLocation == null) return null;
    if (userLocation.longitude == null) return null;
    return userLocation.longitude;
  }
}

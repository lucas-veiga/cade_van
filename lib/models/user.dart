import 'package:location/location.dart';

import 'package:meta/meta.dart';
import './model_exception.dart';

enum UserTypeEnum { DRIVER, RESPONSIBLE }

class User {
  int userId;
  int responsibleId;
  int driverId;
  String email;
  String password;
  String name;
  String phone;
  String cpf;
  String nickname;
  bool isDriving;
  String code;
  UserTypeEnum type;
  LocationData userLocation;

  User({
    @required this.userId,
    @required this.driverId,
    @required this.responsibleId,
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.phone,
    @required this.cpf,
    @required this.nickname,
    @required this.isDriving,
    @required this.code,
    @required this.type,
    @required this.userLocation,
  });

  User.empty();

  User.copy(final User user):
      userId = user.userId,
      responsibleId = user.responsibleId,
      driverId = user.driverId,
      email = user.email,
      password = user.password,
      name = user.name,
      phone = user.phone,
      cpf = user.cpf,
      nickname = user.nickname,
      isDriving = user.isDriving,
      type = user.type,
      userLocation = user.userLocation;


  User.fromJSON(final dynamic json):
      this.userId = json['userId'],
      this.responsibleId = json['responsibleId'],
      this.driverId = json['driverId'],
      this.name = json['name'],
      this.nickname = json['nickname'],
      this.email = json['email'],
      this.phone = json['phone'],
      this.cpf = json['cpf'],
      this.code = json['code'],
      this.type = _userTypeFromJSON(json['perfil']);

  static Map<String, dynamic> toJSON(User user) =>
    {
      'userId': user.userId,
      'responsibleId': user.responsibleId,
      'driverId': user.driverId,
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'phone': user.phone,
      'cpf': user.cpf,
      'nickname': user.nickname,
      'type': _userTypeToJSON(user.type),
    };

  static String _userTypeToJSON(final UserTypeEnum type) {
    if (type == null) {
      throw ModelException('Usuario Without Type');
    }

    if (type == UserTypeEnum.DRIVER) {
      return 'Driver';
    }

    if (type == UserTypeEnum.RESPONSIBLE) {
      return 'Responsible';
    }

    throw ModelException('UserType $type Not Found');
  }

  static UserTypeEnum _userTypeFromJSON(final String type) {
    if (type == null) {
      return null;
    }

    if (type.toLowerCase() == 'driver') {
      return UserTypeEnum.DRIVER;
    }

    if (type.toLowerCase() == 'responsible') {
      return UserTypeEnum.RESPONSIBLE;
    }

    throw ModelException('UserType $type Not Found');
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('User: ');
    buffer.write('{ ');
    buffer.write('userId: $userId, ');
    buffer.write('responsibleId: $responsibleId, ');
    buffer.write('driverId: $driverId, ');
    buffer.write('email: "$email", ');
    buffer.write('password: "$password", ');
    buffer.write('name: "$name", ');
    buffer.write('phone: "$phone", ');
    buffer.write('cpf: "$cpf", ');
    buffer.write('nickname: "$nickname", ');
    buffer.write('isDriving: $isDriving, ');
    buffer.write('code: "$code", ');
    buffer.write('type: "$type", ');
    buffer.write('location: { ');
    buffer.write('latitude: $_latitude, ');
    buffer.write('longitude: $_longitude ');
    buffer.write('}');
    buffer.write(' }');
    return buffer.toString();
  }

  @override
  int get hashCode =>
    userId.hashCode^
    responsibleId.hashCode^
    driverId.hashCode^
    email.hashCode^
    password.hashCode^
    name.hashCode^
    phone.hashCode^
    cpf.hashCode^
    nickname.hashCode^
    isDriving.hashCode^
    code.hashCode^
    type.hashCode^
    _latitude.hashCode^
    _longitude.hashCode;

  bool operator ==(other) =>
    other is User && (
      userId == other.userId &&
        driverId == other.driverId &&
        responsibleId == other.responsibleId &&
        email == other.email &&
        password == other.password &&
        name == other.name &&
        phone == other.phone &&
        cpf == other.cpf &&
        nickname == other.nickname &&
        isDriving == other.isDriving &&
        code == other.code &&
        type == other.type &&
        _latitude == other._latitude &&
        _longitude == other._longitude
    );

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

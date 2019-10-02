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

  User.empty();

  User({
    @required this.id,
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.phone,
    @required this.cpf,
    @required this.nickname,
    @required this.type
  });

  User.fromJSON(final dynamic json, final UserTypeEnum type):
      this.id = json['id'],
      this.email = json['email'],
      this.phone = json['phone'],
      this.name = json['name'],
      this.type = type;

  static Map<String, dynamic> toJSON(User user) =>
    {
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
    buffer.write('type: "$type"');
    buffer.write(' }');
    return buffer.toString();
  }
}

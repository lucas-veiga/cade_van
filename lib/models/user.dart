import 'package:meta/meta.dart';

class User {
  String email;
  String password;
  String name;
  String phone;
  String cpf;
  String nickname;
  UserTypeEnum type;

  User.empty();

  User({
    @required this.email,
    @required this.password,
    @required this.name,
    @required this.phone,
    @required this.cpf,
    @required this.nickname,
    @required this.type
  });

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
    buffer.write('email: $email, ');
    buffer.write('password: $password, ');
    buffer.write('name: $name, ');
    buffer.write('phone: $phone, ');
    buffer.write('cpf: $cpf, ');
    buffer.write('nickname: $nickname, ');
    buffer.write('type: $type');
    buffer.write(' }');
    return buffer.toString();
  }
}

enum UserTypeEnum {
  DRIVER,
  RESPONSIBLE,
}

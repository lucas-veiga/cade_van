import '../models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _user;

  User get user {
    final str = User.toJSON(_user);
    return User.fromJSON(str, _user.type);
  }

  set currentUser(final User user) {
    _user = user;
  }
}

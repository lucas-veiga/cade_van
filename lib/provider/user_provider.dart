import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user;

  User get user => User.copy(_user);

  set currentUser(final User user) {
    _user = user;
    notifyListeners();
  }
}

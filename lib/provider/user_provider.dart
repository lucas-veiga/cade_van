import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user;

  User get user => User.copy(_user);

  set currentUser(final User user) {
    user.isDriving = false;
    _user = user;
    notifyListeners();
  }

  get isDriving => _user.isDriving;

  set isDriving(final bool value) {
    _user.isDriving = value;
    notifyListeners();
  }
}

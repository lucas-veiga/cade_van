import 'package:flutter/material.dart';

import '../models/user.dart';
import './provider_exception.dart';

class UserProvider with ChangeNotifier {
  User _user;
  final List<User> _myDrivers = [];

  User get user => User.copy(_user);

  set currentUser(final User user) {
    user.isDriving = false;
    _user = user;
    notifyListeners();
  }

  List<User> get myDrivers => List.unmodifiable(_myDrivers);

  void setMyDrivers(final bool single, { final User driver, final List<User> drivers }) {
    if (single == true && driver != null) {
      if (driver.type != UserTypeEnum.DRIVER) {
        throw ProviderException('User is not a DRIVER');
      }

      _myDrivers.add(driver);
      notifyListeners();
      return;
    }

    if (single == false && drivers != null && drivers.isNotEmpty) {
      final containsResponsible = drivers.every((item) => item.type == UserTypeEnum.DRIVER);
      if (!containsResponsible) {
        throw ProviderException('Drivers contains an RESPONSIBLE');
      }

      _myDrivers.addAll(drivers);
      notifyListeners();
      return;
    }
  }

  get isDriving => _user.isDriving;

  set isDriving(final bool value) {
    _user.isDriving = value;
    notifyListeners();
  }

  @override
  String toString() {
    return _user.toString();
  }
}

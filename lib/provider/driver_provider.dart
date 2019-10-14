import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/driver_location.dart';

class DriverProvider with ChangeNotifier {
  final List<User> _drivers = [];
  final DriverLocation _driverLocation = DriverLocation();

  List<User> get drivers => List.unmodifiable(_drivers);

  set driver(final User user) {
    _drivers.add(user..type = UserTypeEnum.DRIVER);
    notifyListeners();
  }

  set driverLocation(final DriverLocation driverLocation) {
    _driverLocation.driverName = driverLocation.driverName;
    _driverLocation.driverId = driverLocation.driverId;
    _driverLocation.latitude = driverLocation.latitude;
    _driverLocation.longitude = driverLocation.longitude;
    _driverLocation.isDriving = driverLocation.isDriving;
    notifyListeners();
  }

  get driverLocation => DriverLocation.copy(_driverLocation);
}

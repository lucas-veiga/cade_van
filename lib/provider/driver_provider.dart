import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/driver_location.dart';
import '../models/itinerary.dart';

class DriverProvider with ChangeNotifier {
  final List<User> _drivers = [];
  final List<Itinerary> _itinerary = [];
  final DriverLocation _driverLocation = DriverLocation();

  List<User> get drivers => List.unmodifiable(_drivers);

  set driver(final User user) {
    _drivers.add(user..type = UserTypeEnum.DRIVER);
    notifyListeners();
  }

  get driverLocation => DriverLocation.copy(_driverLocation);

  set driverLocation(final DriverLocation driverLocation) {
    _driverLocation.driverName = driverLocation.driverName;
    _driverLocation.driverId = driverLocation.driverId;
    _driverLocation.latitude = driverLocation.latitude;
    _driverLocation.longitude = driverLocation.longitude;
    _driverLocation.isDriving = driverLocation.isDriving;
    notifyListeners();
  }

  List<Itinerary> get itinerary => List.unmodifiable(_itinerary);

  void emptyItinerary() {
    _itinerary.clear();
    notifyListeners();
  }

  void setItinerary({ final Itinerary single, final List<Itinerary> many }) {
    if (single != null) {
      _itinerary.add(single);
      notifyListeners();
      return;
    }

    if (many != null && many.isNotEmpty) {
      _itinerary.addAll(many);
      notifyListeners();
      return;
    }
  }
}

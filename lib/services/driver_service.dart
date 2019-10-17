import 'dart:convert';

import '../models/user.dart';
import '../models/child.dart';
import '../models/itinerary.dart';

import '../resource/driver_resource.dart';
import '../provider/driver_provider.dart';

class DriverService {
  DriverResource _driverResource = DriverResource();

  Future<void> setMyDrivers(final User user, final Child child, final DriverProvider driverProvider) async {
    final driver = await _driverResource.findResponsibleDriver(user.id, child.driverId);
    driverProvider.driver = driver;
  }

  Future<List<Child>> findMyChildren() async {
    return await _driverResource.findMyChildren();
  }

  Future<void> saveItinerary(final Itinerary itinerary) async {
    final String itineraryJSON = json.encode(Itinerary.toJSON(itinerary));
    await _driverResource.saveItinerary(itineraryJSON);
    print('JSON -> $itinerary');
  }

  Future<void> getAllItinerary(final DriverProvider driverProvider) async {
    final list = await _driverResource.findAll();
    driverProvider.emptyItinerary();
    driverProvider.setItinerary(many: list);
  }
}

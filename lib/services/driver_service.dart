import '../resource/driver_resource.dart';

import '../provider/driver_provider.dart';

import '../models/user.dart';
import '../models/child.dart';

class DriverService {
  DriverResource _driverResource = DriverResource();

  Future<void> setMyDrivers(final User user, final Child child, final DriverProvider driverProvider) async {
    final driver = await _driverResource.findResponsibleDriver(user.id, child.driverId);
    driverProvider.driver = driver;
  }
}

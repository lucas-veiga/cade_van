class DriverLocation {
  double latitude;
  double longitude;
  int driverId;
  String driverName;
  bool isDriving = false;

  DriverLocation();

  DriverLocation.copy(final DriverLocation driverLocation):
      latitude = driverLocation.latitude,
      longitude = driverLocation.longitude,
      driverId = driverLocation.driverId,
      driverName = driverLocation.driverName,
      isDriving = driverLocation.isDriving;

  DriverLocation.fromJSON(final dynamic json):
      latitude = json['latitude'],
      longitude = json['longitude'],
      driverId = json['driverId'],
      isDriving = json['isDriving'],
      driverName = json['driverName'];

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('UserLocation: ');
    buffer.write('{ ');
    buffer.write('latitude: $latitude, ');
    buffer.write('longitude: $longitude, ');
    buffer.write('driverId: $driverId, ');
    buffer.write('driverName: "driverName", ');
    buffer.write('isDriving: $isDriving, ');
    buffer.write('}');
    return buffer.toString();
  }
}

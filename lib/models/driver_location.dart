import 'package:location/location.dart';

class DriverLocation {
  final double latitude;
  final double longitude;
  final int driverId;
  final String driverName;
  final bool isDriving;
  final int itineraryId;

  DriverLocation():
    latitude = null,
    longitude = null,
    driverId = null,
    isDriving = null,
    itineraryId = null,
    driverName = null;

  DriverLocation.create(final LocationData position, final bool isStopping, final int driverId, final int itineraryId, final String driverName):
    latitude = position.latitude,
    longitude = position.longitude,
    driverId = driverId,
    isDriving = isStopping,
    itineraryId = itineraryId,
    driverName = driverName;

  DriverLocation.copy(final DriverLocation driverLocation):
      latitude = driverLocation.latitude,
      longitude = driverLocation.longitude,
      driverId = driverLocation.driverId,
      isDriving = driverLocation.isDriving,
      itineraryId = driverLocation.itineraryId,
      driverName = driverLocation.driverName;

  DriverLocation.fromJSON(final dynamic json):
      latitude = json['latitude'],
      longitude = json['longitude'],
      driverId = json['driverId'],
      isDriving = json['isDriving'],
      itineraryId = json['itineraryId'],
      driverName = json['driverName'];

  static Map<String, dynamic> toJSON(final DriverLocation location) =>
    {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'driverId': location.driverId,
      'isDriving': location.isDriving,
      'itineraryId': location.itineraryId,
      'driverName': location.driverName,
    };

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('UserLocation: ');
    buffer.write('{ ');
    buffer.write('latitude: $latitude, ');
    buffer.write('longitude: $longitude, ');
    buffer.write('driverId: $driverId, ');
    buffer.write('isDriving: $isDriving, ');
    buffer.write('itineraryId: $itineraryId, ');
    buffer.write('driverName: "driverName", ');
    buffer.write('}');
    return buffer.toString();
  }
}

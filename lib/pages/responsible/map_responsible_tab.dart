import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../provider/user_provider.dart';
import '../../provider/driver_provider.dart';

import '../../models/user.dart';
import '../../models/driver_location.dart';

class MapResponsibleTab extends StatefulWidget {
  @override
  _MapResponsibleTabState createState() => _MapResponsibleTabState();
}

class _MapResponsibleTabState extends State<MapResponsibleTab> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _driverIcon;
  Set<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    final DriverLocation driverLocation = Provider.of<DriverProvider>(context).driverLocation;

    _createMarkerImageFromAsset(context);
    _addUsers(user, driverLocation);

    return Stack(
      children: <Widget>[
        GoogleMap(
          markers: _markers,
          onMapCreated: (final GoogleMapController controller) => _controller.complete(controller),
          initialCameraPosition: CameraPosition(
            target: LatLng(user.userLocation.latitude, user.userLocation.longitude),
            zoom: 15,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status do Motorista: ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  driverLocation.isDriving ? 'Em Movimento' : 'Parado',
                  style: TextStyle(
                    color: driverLocation.isDriving ? Colors.green : Colors.orange,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addUsers(final User user, final DriverLocation driverLocation) {
    _markers = {
      Marker(
        markerId: MarkerId('MyPosition'),
        position: LatLng(user.userLocation.latitude, user.userLocation.longitude),
        infoWindow: InfoWindow(
          title: 'Minha Posição'
        ),
      ),
    };

    if (driverLocation.isDriving) {
      print('\n\n\tADDING NEW MARKER -> LAT: ${driverLocation.latitude} | LON: ${driverLocation.longitude} - ${driverLocation.driverId}');
      _markers.add(
        Marker(
          markerId: MarkerId('Driver_${driverLocation.driverName}_${driverLocation.driverId}'),
          position: LatLng(driverLocation.latitude, driverLocation.longitude),
          icon: _driverIcon,
          infoWindow: InfoWindow(
            title: driverLocation.driverName,
          ),
        ),
      );
    }
  }

  void _createMarkerImageFromAsset(final BuildContext context) {
    final ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      'assets/images/school_bus.png',
    ).then(_updateBitMap);
  }

  void _updateBitMap(final BitmapDescriptor bitmapDescriptor) =>
    setState(() => _driverIcon = bitmapDescriptor);
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../provider/user_provider.dart';

import '../../models/user.dart';

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
    final User user = Provider.of<UserProvider>(context, listen: false).user;
    _createMarkerImageFromAsset(context);
    _addMarker(user);

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
                  'Em movimento',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addMarker(final User user) {
    _markers = {
      Marker(
        markerId: MarkerId('Mototorista'),
        position: LatLng(user.userLocation.latitude, user.userLocation.longitude),
        icon: _driverIcon,
        infoWindow: InfoWindow(
          title: 'Motorista'
        ),
      ),
    };
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
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
    _createMarkerImageFromAsset(context);

    return Stack(
      children: <Widget>[
        Consumer<DriverProvider>(
          builder: (ctx, final DriverProvider provider, _) => GoogleMap(
//          markers: _markers,
            onMapCreated: (final GoogleMapController controller) => _controller.complete(controller),
            initialCameraPosition: CameraPosition(
              target: LatLng(provider.driverLocation.latitude, provider.driverLocation.longitude),
              zoom: 15,
            ),
          ),
        ),
      ],
    );
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

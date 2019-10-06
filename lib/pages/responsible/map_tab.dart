import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../provider/user_provider.dart';

import '../../models/user.dart';

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).user;

    return GoogleMap(
      onMapCreated: (final GoogleMapController controller) => _controller.complete(controller),
      initialCameraPosition: CameraPosition(
        target: LatLng(user.userLocation.latitude, user.userLocation.longitude),
        zoom: 15,
      ),
    );
  }
}

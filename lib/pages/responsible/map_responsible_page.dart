import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../provider/driver_provider.dart';
import '../../models/driver_location.dart';
import '../../utils/application_color.dart';
import '../../widgets/default_alert_dialog.dart';

class MapResponsiblePage extends StatefulWidget {
  @override
  _MapResponsiblePageState createState() => _MapResponsiblePageState();
}

class _MapResponsiblePageState extends State<MapResponsiblePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  BitmapDescriptor _driverIcon;

  @override
  Widget build(BuildContext context) {
    final DriverProvider provider = Provider.of<DriverProvider>(context);
    _createMarkerImageFromAsset(context);

    return Scaffold(
      key: _navigatorKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _buildMarkers(provider.driverLocation),
            initialCameraPosition: CameraPosition(
              target: LatLng(provider.driverLocation.latitude, provider.driverLocation.longitude),
              zoom: 15,
            ),
          ),
          if (!provider.driverLocation.isDriving) DefaultAlertDialog(
            context,
            stringTitle: 'O Motorista terminou a viagem',
            stringTitleColor: ApplicationColorEnum.SUCCESS,
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers(final DriverLocation driverLocation) {
    return {
      Marker(
        markerId: MarkerId(_buildMarkerId(driverLocation)),
        position: LatLng(driverLocation.latitude, driverLocation.longitude),
        infoWindow: InfoWindow(
          title: driverLocation.driverName,
        ),
        icon: _driverIcon,
      ),
    };
  }

  String _buildMarkerId(final DriverLocation driverLocation) =>
    '${driverLocation.driverName}_${driverLocation.driverId}';

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

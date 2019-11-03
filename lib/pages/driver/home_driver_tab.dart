import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';
import '../../widgets/toast.dart';

import '../../services/driver_service.dart';
import '../../services/routes_service.dart';
import '../../services/service_exception.dart';

import '../../provider/driver_provider.dart';
import '../../models/itinerary.dart';

class HomeDriverPage extends StatelessWidget {
  final DriverService _driverService = DriverService();
  final RoutesService _routesService = RoutesService();

  final StreamController<bool> _blockUIStream;
  final Toast _toast = Toast();

  HomeDriverPage(this._blockUIStream);

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (_, final DriverProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.itinerary.length,
          itemBuilder: (_, final int i) =>
            InkWell(
              onTap: () => _initItinerary(context, provider, provider.itinerary[i]),
              onLongPress: () => _routesService.goToItineraryDetail(context, provider.itinerary[i], true),
              child: ItineraryItem(provider.itinerary[i]),
            ),
        ),
    );
  }

  Future<void> _initItinerary(final BuildContext context, final DriverProvider provider, final Itinerary itinerary) async {
    try {
      _driverService.initItinerary(context, provider, itinerary, _blockUIStream);
    } on ServiceException catch(err) {
      _toast.show(err.msg, context);
    }
  }
}

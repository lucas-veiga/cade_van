import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';

import '../../services/driver_service.dart';
import '../../services/routes_service.dart';

import '../../provider/driver_provider.dart';

class HomeDriverPage extends StatelessWidget {
  final DriverService _driverService = DriverService();
  final RoutesService _routesService = RoutesService();

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (_, final DriverProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.itinerary.length,
          itemBuilder: (_, final int i) =>
            InkWell(
              onTap: () => _routesService.goToItineraryDetail(context, provider.itinerary[i], true),
              onLongPress: () => _driverService.initItinerary(context, provider, provider.itinerary[i]),
              child: ItineraryItem(provider.itinerary[i]),
            ),
        ),
    );
  }
}

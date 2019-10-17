import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';

import '../../provider/driver_provider.dart';

class HomeDriverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (_, final DriverProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.itinerary.length,
          itemBuilder: (_, final int i) =>
          InkWell(
            onTap: () => print('DO SOMETHING'),
            child: ItineraryItem(provider.itinerary[i]),
          ),
        ),
    );
  }
}

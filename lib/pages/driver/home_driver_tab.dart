import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';
import '../../widgets/modal.dart';

import '../../services/driver_service.dart';
import '../../services/routes_service.dart';

import '../../provider/driver_provider.dart';
import '../../utils/application_color.dart';
import '../../models/itinerary.dart';

class HomeDriverPage extends StatelessWidget {
  final DriverService _driverService = DriverService();
  final RoutesService _routesService = RoutesService();

  final Modal _modal = Modal();

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (_, final DriverProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.itinerary.length,
          itemBuilder: (_, final int i) =>
          InkWell(
            onTap: () => _onItineraryClick(context, provider.itinerary[i]),
            child: ItineraryItem(provider.itinerary[i]),
          ),
        ),
    );
  }

  Future<void> _onItineraryClick(final BuildContext context, final Itinerary itinerary) async{
    final answer = await _modal.showModal(
      context,
      stringTitle: 'Iniciar o itineraio: ${itinerary.description}',
      stringTitleColor: ApplicationColorEnum.MAIN,
      stringContent: 'Tem certeza certeza que quer iniciar uma viagem?',
      actions: _buildModalInitItineraryActions(context, itinerary),
    );

    if (answer != null && answer == true) {
      _routesService.goToItineraryDetail(context, itinerary);
    }
  }

 List<FlatButton> _buildModalInitItineraryActions(final BuildContext context, final Itinerary itinerary) =>
   [
     FlatButton(
       child: Text('Iniciar'),
       onPressed: () {
         final res = Navigator.pop(context, true);
         if (res) _driverService.initItinerary(context, itinerary);
       },
     ),
     FlatButton(
       child: Text(
         'Cancelar',
         style: TextStyle(
           color: Colors.red,
         ),
       ),
       onPressed: () => Navigator.pop(context, false),
     ),
   ];
}

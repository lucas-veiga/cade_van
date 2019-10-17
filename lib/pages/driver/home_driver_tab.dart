import 'package:cade_van/models/itinerary.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';
import '../../widgets/modal.dart';

import '../../provider/driver_provider.dart';
import '../../utils/application_color.dart';
import '../../services/driver_service.dart';

class HomeDriverPage extends StatelessWidget {
  final Modal _modal = Modal();
  final DriverService _driverService = DriverService();

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (_, final DriverProvider provider, __) =>
        ListView.separated(
          separatorBuilder: (_, __) => CustomDivider(height: 0),
          itemCount: provider.itinerary.length,
          itemBuilder: (_, final int i) =>
          InkWell(
            onTap: () => _modal.showModal(
              context,
              stringTitle: 'Iniciar o itineraio: ${provider.itinerary[i].description}',
              stringTitleColor: ApplicationColorEnum.MAIN,
              stringContent: 'Tem certeza certeza que quer iniciar uma viagem?',
              actions: _buildModalInitItineraryActions(context, provider.itinerary[i]),
            ),
            child: ItineraryItem(provider.itinerary[i]),
          ),
        ),
    );
  }

 List<FlatButton> _buildModalInitItineraryActions(final BuildContext context, final Itinerary itinerary) =>
   [
     FlatButton(
       child: Text('Iniciar'),
       onPressed: () {
         final res = Navigator.pop(context);
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
       onPressed: () => Navigator.pop(context),
     ),
   ];


}

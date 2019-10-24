import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/custom_divider.dart';
import '../../widgets/itinerary_item.dart';
import '../../widgets/default_alert_dialog.dart';

import '../../services/driver_service.dart';
import '../../services/routes_service.dart';

import '../../provider/driver_provider.dart';
import '../../utils/application_color.dart';
import '../../models/itinerary.dart';

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
              onLongPress: () => _onItineraryClick(context, provider, provider.itinerary[i]),
              child: ItineraryItem(provider.itinerary[i]),
            ),
        ),
    );
  }

  Future<void> _onItineraryClick(final BuildContext context, final DriverProvider driverProvider, final Itinerary itinerary) async{
    final hasItineraryActivated = driverProvider.itinerary.any((item) => item.isAtivo == true);
    if (hasItineraryActivated) {
      final itineraryActivated = driverProvider
        .itinerary
        .singleWhere((item) => item.isAtivo == true);

      if (itineraryActivated == itinerary) {
        _routesService.goToItineraryDetail(context, itinerary);
        return;
      } else {
        driverProvider.itinerary.singleWhere((item) => item.isAtivo == true);
        await showDialog(
          context: context,
          builder: (final BuildContext ctx) =>
            DefaultAlertDialog(
              ctx,
              stringTitle: 'Você já tem um itinerário em andamento',
              stringTitleColor: ApplicationColorEnum.ERROR,
              stringContent: 'O itinerário ${itineraryActivated.description} está ativo.\nFinalize o ${itineraryActivated.description} antes de inicar outro itinerário',
            ),
        );
        return;
      }
    }

    final answer = await showDialog(
      context: context,
      builder: (final BuildContext ctx) =>
        DefaultAlertDialog(
          ctx,
          stringTitle: 'Iniciar o itineraio: ${itinerary.description}',
          stringContent: 'Tem certeza certeza que quer iniciar uma viagem?',
          actions: _buildModalInitItineraryActions(context, ctx, itinerary),
        ),
    );

    if (answer != null && answer == true) {
      _routesService.goToItineraryDetail(context, itinerary);
    }
  }

  List<FlatButton> _buildModalInitItineraryActions(final BuildContext context, final BuildContext alertContext, final Itinerary itinerary) =>
    [
      FlatButton(
        child: Text('Iniciar'),
        onPressed: () {
          final res = Navigator.pop(alertContext, true);
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

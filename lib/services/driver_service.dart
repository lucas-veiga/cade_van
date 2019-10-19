import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:catcher/core/catcher.dart';
import 'package:location/location.dart';

import '../models/user.dart';
import '../models/child.dart';
import '../models/itinerary.dart';

import './service_exception.dart';
import './socket_location_service.dart';

import '../widgets/modal.dart';
import '../environments/environment.dart';
import '../utils/application_color.dart';
import '../resource/driver_resource.dart';
import '../provider/driver_provider.dart';

class DriverService {
  DriverResource _driverResource = DriverResource();
  Modal _modal = Modal();
  Location _location = Location();

  Future<void> setMyDrivers(final User user, final Child child, final DriverProvider driverProvider) async {
    final driver = await _driverResource.findResponsibleDriver(user.id, child.driverId);
    driverProvider.driver = driver;
  }

  Future<List<Child>> findMyChildren() async {
    return await _driverResource.findMyChildren();
  }

  Future<void> saveItinerary(final Itinerary itinerary) async {
    final String itineraryJSON = json.encode(Itinerary.toJSON(itinerary));
    await _driverResource.saveItinerary(itineraryJSON);
    print('JSON -> $itinerary');
  }

  Future<void> getAllItinerary(final DriverProvider driverProvider) async {
    final list = await _driverResource.findAll();
    driverProvider.emptyItinerary();
    driverProvider.setItinerary(many: list);
  }

  Future<void> initItinerary(final BuildContext context, final Itinerary itinerary) async {
    await _onInitItinerary(context);
    SocketLocationService.init();
  }

  Future<void> _onInitItinerary(final BuildContext context) async {
    final res = await _location.requestPermission();
    if (res == null) return;

    if (!res) {
      _modal.showModal(
        context,
        stringTitle: 'Localização Necessaria',
        stringContent: 'O ${Environment.APP_NAME} precisa acessar sua localização',
        stringTitleColor: ApplicationColorEnum.WARNING,
        actions: _buildModaLocationActions(context),
      );
    }
  }

  List<FlatButton> _buildModaLocationActions(final BuildContext context) =>
    <FlatButton>[
      FlatButton(
        onPressed: () async => await _handleActionPressed(context),
        child: Text(
          'OK',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ];

  Future<void> _handleActionPressed(final BuildContext context) async {
    int attempts = 0;
    final int maxAttempt = 3;

    try {
      bool res = false;

      do {
        print('Iniciando $attempts tentativa para pedir localizacao');
        res = await _location.requestPermission();

        if (res) {
          Navigator.pop(context);
          return;
        } else {
          attempts++;
        }
      } while (!res && attempts <= maxAttempt);

      if (!res && attempts <= maxAttempt) {
        _modal.showModal(
          context,
          stringTitle: 'Erro ao pegar a localização',
          stringTitleColor: ApplicationColorEnum.ERROR,
          stringContent: 'Limite máximo de tentativas excedido',
        );
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Nao foi possivel pedir a localizacao ao usuario', err);
    }
  }
}

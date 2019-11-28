import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:catcher/core/catcher.dart';
import 'package:location/location.dart';

import '../models/child.dart';
import '../models/itinerary.dart';

import './service_exception.dart';
import './socket_location_service.dart';
import './routes_service.dart';
import './child_service.dart';

import '../provider/driver_provider.dart';
import '../provider/user_provider.dart';


import '../resource/driver_resource.dart';
import '../resource/resource_exception.dart';

import '../utils/application_color.dart';
import '../environments/environment.dart';
import '../socket/socket_exception.dart';
import '../widgets/default_alert_dialog.dart';

class DriverService {
  final DriverResource _driverResource  = DriverResource();
  final ChildService _childService      = ChildService();
  final RoutesService _routesService    = RoutesService();

  static const String DEFAULT_MESSAGE = 'Não foi possivel ';
  Location _location = Location();

  Future<List<Child>> findMyChildren() async {
    try {
      return await _driverResource.findMyChildren();
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar suas crianças', err);
    }
  }

  Future<String> findMyCode() async {
    try {
      return await _driverResource.findMyCode();
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE pegar seu código', err);
    }
  }

  Future<void> saveItinerary(final Itinerary itinerary, [final bool delay = false]) async {
    if (delay) {
      await Future.delayed(Duration(seconds: 3));
    }
    try {
      final String itineraryJSON = json.encode(Itinerary.toJSON(itinerary));
      await _driverResource.saveItinerary(itineraryJSON);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE salvar o itinerário', err);
    }
  }

  Future<Itinerary> findItinerary(final int itineraryId) async {
    try {
      return await _driverResource.findItinerary(itineraryId);
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE encontrar o itinerário');
    }
  }

  Future<List<Itinerary>> setAllItinerary(final DriverProvider driverProvider) async {
    try {
      final list = await _driverResource.findAll();
      driverProvider.emptyItinerary();
      driverProvider.setItinerary(many: list);
      return list;
    } on ResourceException catch(err) {
      throw ServiceException(err.msg, err);
    } catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('$DEFAULT_MESSAGE encontrar todos os itinerários', err);
    }
  }

  Future<void> initItinerary(final BuildContext context, final DriverProvider driverProvider, final Itinerary itinerary, final StreamController<bool> blockUIStream) async{
    print('\nINITING ITINARY!\n');
     try {
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

       await showDialog(
         context: context,
         builder: (final BuildContext ctx) =>
           DefaultAlertDialog(
             ctx,
             stringTitle: 'Iniciar o itinerário: ${itinerary.description}',
             stringContent: 'Tem certeza certeza que quer iniciar uma viagem?',
             actions: _buildModalInitItineraryActions(blockUIStream, context, ctx, itinerary),
           ),
       );
     } on ResourceException catch(err) {
       throw ServiceException(err.msg, err);
     } on SocketException catch(err, stack) {
       Catcher.reportCheckedError(err, stack);
       throw ServiceException('$DEFAULT_MESSAGE iniciar o socket', err);
     } catch(err, stack) {
       Catcher.reportCheckedError(err, stack);
       throw ServiceException('$DEFAULT_MESSAGE iniciar o itinerário', err);
     }
  }

  List<FlatButton> _buildModalInitItineraryActions(final StreamController<bool> blockUIStream, final BuildContext context, final BuildContext alertContext, final Itinerary itinerary) =>
    [
      FlatButton(
        child: Text('Iniciar'),
        onPressed: () async {
          Navigator.pop(alertContext, true);
          await _onInitItinerary(blockUIStream, context, itinerary);
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

  Future<void> _onInitItinerary(final StreamController<bool> blockUIStream, final BuildContext context, final Itinerary itinerary) async {
    try {
      blockUIStream.add(true);
      await checkGPSPermission(context);
      await _driverResource.initItinerary(itinerary.id);

      final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

      await SocketLocationService.init(userProvider, itinerary);
      SocketLocationService.sendLocation();
      await setAllItinerary(driverProvider);
      await _childService.updateStatusWaiting(itinerary.id);

      final itineraryFromServer = await findItinerary(itinerary.id);
      _routesService.goToItineraryDetail(context, itineraryFromServer);
    } finally {
      blockUIStream.add(false);
    }
  }

  Future<void> finishItinerary(final BuildContext context, final int itineraryId) async {
    final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

    SocketLocationService.sendLocation(false);
    _driverResource.finishItinerary(itineraryId)
      .then((_) {
      Future.delayed(Duration(seconds: 1), SocketLocationService.close)
        .then((_) => setAllItinerary(driverProvider));
    });

  }

  Future<void> checkGPSPermission(final BuildContext context) async {
    final res = await _location.requestPermission();
    if (res == null) return;

    if (!res) {
      await showDialog(
        context: context,
        builder: (final BuildContext ctx) =>
          DefaultAlertDialog(
            ctx,
            stringTitle: 'Localização Necessaria',
            stringContent: 'O ${Environment.APP_NAME} precisa acessar sua localização',
            stringTitleColor: ApplicationColorEnum.WARNING,
            actions: _buildModaLocationActions(ctx),
          ),
      );
    }

    final isGPSActivated = await _location.requestService();
    if (!isGPSActivated) {
      await showDialog(
        context: context,
        builder: (final BuildContext ctx) =>
          DefaultAlertDialog(
            ctx,
            stringTitle: 'Localização Necessaria',
            stringContent: 'O ${Environment.APP_NAME} precisa que o GPS esteja ligado',
            stringTitleColor: ApplicationColorEnum.WARNING,
            actions: _buildModaGPSActivatedActions(ctx),
          ),
      );
    }
  }

  List<FlatButton> _buildModaGPSActivatedActions(final BuildContext context) =>
    [
      FlatButton(
        onPressed: () async => await _handleActionGPSActivatedPressed(context),
        child: Text(
          'OK',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      )
    ];

  Future<void> _handleActionGPSActivatedPressed(final BuildContext context) async {
    int attempts = 0;
    final int maxAttempt = 3;

    try {
      bool res = false;

      do {
        print('Iniciando $attempts tentativa para abilitar GPS');
        res = await _location.requestService();

        if (res) {
          Navigator.pop(context);
          return;
        } else {
          attempts++;
        }
      } while (!res && attempts <= maxAttempt);

      if (!res && attempts <= maxAttempt) {
        showDialog(
          context: context,
          builder: (final BuildContext ctx) =>
            DefaultAlertDialog(
              ctx,
              stringTitle: 'Erro ao pegar a localização',
              stringTitleColor: ApplicationColorEnum.ERROR,
              stringContent: 'Limite máximo de tentativas excedido',
            ),
        );
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Nao foi possivel pedir a localizacao ao usuario', err);
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
        showDialog(
          context: context,
          builder: (final BuildContext ctx) =>
            DefaultAlertDialog(
              ctx,
              stringTitle: 'Erro ao pegar a localização',
              stringTitleColor: ApplicationColorEnum.ERROR,
              stringContent: 'Limite máximo de tentativas excedido',
            ),
        );
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ServiceException('Nao foi possivel pedir a localizacao ao usuario', err);
    }
  }
}

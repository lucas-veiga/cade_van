import 'dart:math';

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:stomp/stomp.dart';

import '../provider/user_provider.dart';
import '../provider/driver_provider.dart';
import '../provider/child_provider.dart';

import '../socket/web_socket.dart';
import '../socket/socket_events.dart';

import '../models/driver_location.dart';
import '../models/itinerary.dart';

import './service_exception.dart';
import './child_service.dart';

import '../environments/environment.dart';
import '../widgets/toast.dart';
import '../utils/application_color.dart';

class SocketLocationService {
  static final ChildService _childService = ChildService();

  static final Toast _toast = Toast();
  static Location _location = Location();
  static bool _isFirstRequest = true;

  static UserProvider _userProvider;
  static Itinerary _itinerary;
  static StompClient _stomp;
  static WebSocket _webSocket;
  static StreamSubscription<LocationData> _streamSubscriptionLocation;

  static Future<void> init(final UserProvider userProvider, [ final Itinerary itinerary ]) async {
    isDisconnected();
    try {
      _webSocket = WebSocket();
      _stomp = await _webSocket.connect(Environment.SOCKET);
      _userProvider = userProvider;
      _itinerary = itinerary;
    } catch (err) {
      close(false);
      throw ServiceException('Erro ao abrir conexcao Socket', err);
    }
  }

  static void close([final bool closeConnections = true]) {
    if (closeConnections) {
      _isConnected();
      _isSharingLocation();
      _streamSubscriptionLocation.cancel();
      _stomp.disconnect();
    }

    _userProvider = null;
    _itinerary = null;
    _stomp = null;
    _webSocket = null;
    _streamSubscriptionLocation = null;
  }

  static void sendLocation([final bool isDriving = true]) {
    _isConnected();
    if (!isDriving) {
      _streamSubscriptionLocation.cancel();
      _streamSubscriptionLocation = null;
    }

    _streamSubscriptionLocation = _location.onLocationChanged()
      .listen((value) => _handleLocationChanging(value, isDriving));
  }

  static void listenLocation(final BuildContext context) {
    _isConnected();
    _userProvider.myDrivers
    .forEach((item) {
      final randId = new Random().nextInt(9999).toString();
      _stomp.subscribeJson(randId, _buildListningEventMessage(item.id), (final Map<String, String> headers, final dynamic message) async {
        final driverLocation = DriverLocation.fromJSON(message);
        if (_isFirstRequest) {
          final childProvider = Provider.of<ChildProvider>(context, listen: false);
          _isFirstRequest = false;
          await _childService.setAllChildren(childProvider);
//          _toast.show('O ${driverLocation.driverName} saiu de casa', context, backgroundColor: ApplicationColorEnum.SUCCESS);
        }
        if (!driverLocation.isDriving) {
          _isFirstRequest = true;
        }
      });
    });
  }

  static bool isDisconnected([final bool throwException = true]) {
    if (throwException) {
      if (_webSocket != null || (_stomp != null && !_stomp.isDisconnected)) {
        throw ServiceException('Feche a conexao do socket antes de abri outra');
      }
    }

    return _webSocket != null || (_stomp != null && !_stomp.isDisconnected);
  }

  static _handleReceivingLocation(final dynamic value, final DriverProvider driverProvider) {
    final location = DriverLocation.fromJSON(value);
    driverProvider.driverLocation = location;
  }

  static _handleLocationChanging(final LocationData position, final bool isDriving) {
    if (position == null) {
      throw ServiceException('Nao foi possivel pegar a localizacao do usuario');
    }

    if (_itinerary == null) {
      throw ServiceException('Itinerario nao foi informado!');
    }

    final driverLocationMap =
    DriverLocation.toJSON(
      DriverLocation.create(position, isDriving, _userProvider.user.id, _itinerary.id, _userProvider.user.name),
    );
    _userProvider.isDriving = isDriving;
    _stomp.sendJson(_buildSendEventMessage(position), driverLocationMap);
  }

  static void _isConnected() {
    if (_webSocket == null || _stomp == null) {
      throw ServiceException('Nenhum Socket iniciado');
    }
  }
  static void _isSharingLocation() {
    if (_streamSubscriptionLocation == null) {
      throw ServiceException('Usuario nao esta compartilhando localizacao');
    }
  }

  static String _buildSendEventMessage(final LocationData locationData) =>
    '${SocketEvents.convertEnum(SocketEventsEnum.SEND_LOCATION)}/${_userProvider.user.id}';

  static String _buildListningEventMessage(final int driverId) =>
    '/topic/location/$driverId';
}

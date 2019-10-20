import 'dart:async';

import 'package:location/location.dart';
import 'package:stomp/stomp.dart';

import '../provider/user_provider.dart';
import '../provider/driver_provider.dart';

import '../socket/web_socket.dart';
import '../socket/socket_events.dart';

import '../models/driver_location.dart';
import '../models/itinerary.dart';

import './service_exception.dart';
import '../environments/environment.dart';

class SocketLocationService {
  static Location _location = Location();

  static UserProvider _userProvider;
  static Itinerary _itinerary;
  static StompClient _stomp;
  static WebSocket _webSocket;
  static StreamSubscription<LocationData> _streamSubscriptionLocation;

  static Future<void> init(final Itinerary itinerary, final UserProvider userProvider) async {
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

  static void listenLocation(final DriverProvider driverProvider) {
//    _isConnected();
//    _webSocket.listenMessage((value) =>
//      _handleReceivingLocation(value, driverProvider), customEvent: _buildListenEventMessage(driverProvider.drivers.first));
  }

  static _handleReceivingLocation(final dynamic value, final DriverProvider driverProvider) {
    final location = DriverLocation.fromJSON(value);
    driverProvider.driverLocation = location;
  }

  static _handleLocationChanging(final LocationData position, final bool isDriving) {
    if (position == null) {
      throw ServiceException('Nao foi possivel pegar a localizacao do usuario');
    }

    final driverLocationMap =
    DriverLocation.toJSON(
      DriverLocation.create(position, isDriving, _userProvider.user.id, _itinerary.id, _userProvider.user.name),
    );
    _userProvider.isDriving = isDriving;
    _stomp.sendJson(_buildListenEventMessage(position), driverLocationMap);
  }

  static void _isConnected() {
    if (_webSocket == null || _stomp == null) {
      throw ServiceException('Nenhum Socket iniciado');
    }
  }

  static bool isDisconnected([final bool throwException = true]) {
    if (throwException) {
      if (_webSocket != null || (_stomp != null && !_stomp.isDisconnected)) {
        throw ServiceException('Feche a conexao do socket antes de abri outra');
      }
    }

    if (_webSocket != null || (_stomp != null && !_stomp.isDisconnected)) {
      return true;
    }
    return false;
  }

  static void _isSharingLocation() {
    if (_streamSubscriptionLocation == null) {
      throw ServiceException('Usuario nao esta compartilhando localizacao');
    }
  }

  static String _buildListenEventMessage(final LocationData locationData) =>
    SocketEvents.convertEnum(SocketEventsEnum.SEND_LOCATION)
      + '/${_userProvider.user.id}';
}

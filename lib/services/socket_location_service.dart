import 'dart:async';

import 'dart:convert';

import 'package:location/location.dart';

import '../provider/user_provider.dart';
import '../provider/driver_provider.dart';

import '../socket/web_socket.dart';
import '../socket/socket_events.dart';

import '../models/driver_location.dart';
import '../models/user.dart';

import './service_exception.dart';

class SocketLocationService {
  static UserProvider _userProvider;
  static Location _location = Location();
  static WebSocket _webSocket;
  static StreamSubscription<LocationData> _streamSubscriptionLocation;

  static void close() {
    _streamSubscriptionLocation.cancel();
    _webSocket.disconnect();
    _webSocket = null;
    _userProvider = null;
    _streamSubscriptionLocation = null;
  }

  static init(final UserProvider userProvider) {
    if (_webSocket != null) {
      throw ServiceException('Feche a conexao do socket antes de abri outra');
    }

    _userProvider = userProvider;
    _webSocket = WebSocket.driverPosition();
  }

  static void sendLocation([final bool isStopping = false]) {
    if (_webSocket == null) {
      throw ServiceException('Nenhum Socket iniciado');
    }

    if (isStopping) {
      _streamSubscriptionLocation.cancel();
      _streamSubscriptionLocation = null;
    }

    _streamSubscriptionLocation = _location.onLocationChanged()
      .listen((value) => _handleLocationChanging(value, isStopping));
  }

  static void listenLocation(final DriverProvider driverProvider) {
    if (_webSocket == null) {
      throw ServiceException('Nenhum Socket iniciado');
    }
    _webSocket.listenMessage((value) =>
      _handleReceivingLocation(value, driverProvider), customEvent: _buildListenEventMessage(driverProvider.drivers.first));
  }

  static _handleReceivingLocation(final dynamic value, final DriverProvider driverProvider) {
    final location = DriverLocation.fromJSON(value);
    driverProvider.driverLocation = location;
  }

  static _handleLocationChanging(final LocationData position, final bool isStopping) {
    if (position == null) {
      print('\n\n---------------- POSITION IS NULL ----------------\n\n');
      return;
    }

    _webSocket.sendMessage(SocketEventsEnum.SHARING_LOCATION, getBody(position, isStopping));
  }

  static String getBody(final LocationData value, final bool isStopping) {
    final map = {
      'driverName': _userProvider.user.name,
      'driverId': _userProvider.user.id,
      'latitude': value.latitude,
      'longitude': value.longitude,
      'isDriving': !isStopping,
    };
    return json.encode(map);
  }

  static String _buildListenEventMessage(final User user) =>
    SocketEvents.convertEnum(SocketEventsEnum.SHARING_LOCATION)
      + '_'
      + user.id.toString();
}

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
import '../socket/socket_exception.dart';

import '../models/driver_location.dart';
import '../models/itinerary.dart';

import './child_service.dart';

import '../environments/environment.dart';

class SocketLocationService {
  static final ChildService _childService = ChildService();

  static Location _location = Location();
  static bool _isFirstRequest = true;

  static UserProvider _userProvider;
  static Itinerary _itinerary;
  static StompClient _stomp;
  static WebSocket _webSocket;
  static StreamSubscription<LocationData> _streamSubscriptionLocation;

  static Future<void> init(final UserProvider userProvider, [ final Itinerary itinerary ]) async {
    isConnected();
    try {
      _webSocket = WebSocket();
      _stomp = await _webSocket.connect(Environment.SOCKET);
      _userProvider = userProvider;
      _itinerary = itinerary;
    } catch (err) {
      close(false);
      throw SocketException('Erro ao abrir conexcao Socket', err);
    }
  }

  static void close([final bool closeConnections = true]) {
    if (closeConnections) {
      isDisconnected();
      if (_isSharingLocation()) {
        _streamSubscriptionLocation.cancel();
        _streamSubscriptionLocation = null;
      }
      _stomp.disconnect();
    }

    _userProvider = null;
    _itinerary = null;
    _stomp = null;
    _webSocket = null;
    _streamSubscriptionLocation = null;
  }

  static void sendLocation([final bool isDriving = true]) {
    isDisconnected();
    if (!isDriving) {
      _streamSubscriptionLocation.cancel();
      _streamSubscriptionLocation = null;
    }

    _streamSubscriptionLocation = _location.onLocationChanged()
      .listen((value) => _handleLocationChanging(value, isDriving));
  }

  static void listenLocation(final BuildContext context) {
    isDisconnected();
    final DriverProvider driverProvider = Provider.of<DriverProvider>(context, listen: false);

    _userProvider?.myDrivers
      ?.forEach((item) {
      final randId = new Random().nextInt(9999).toString();
      _stomp.subscribeJson(
        randId,
        _buildListeningEventMessage(item.userId),
          (_, msg) => _handleReceivingMsg(driverProvider, context, msg)
      );
    });
  }

  static bool isConnected([final bool throwException = true]) {
    if (throwException) {
      if (_webSocket != null && (_stomp != null && !_stomp.isDisconnected)) {
        throw SocketException('Ja existe uma conexao do socket aberta');
      }
    }

    return _webSocket != null || (_stomp != null && !_stomp.isDisconnected);
  }

  static bool isDisconnected([final bool throwException = true]) {
    if (throwException) {
      if (_webSocket == null && _stomp == null) {
        throw SocketException('Nenhuma conexao do socket foi iniciada');
      }
    }

    return _webSocket == null && _stomp == null;
  }

  static _handleLocationChanging(final LocationData position, final bool isDriving) {
    if (position == null) {
      throw SocketException('Nao foi possivel pegar a localizacao do usuario');
    }

    if (_itinerary == null) {
      throw SocketException('Itinerario nao foi informado!');
    }

    final driverLocationMap =
    DriverLocation.toJSON(
      DriverLocation.create(position, isDriving, _userProvider.user.userId, _itinerary.id, _userProvider.user.name),
    );
    _userProvider.isDriving = isDriving;
    _stomp.sendJson(_buildSendEventMessage(position), driverLocationMap);
  }

  static bool _isSharingLocation() {
    return _streamSubscriptionLocation != null;
  }

  static Future<void> _handleReceivingMsg(final DriverProvider driverProvider, final BuildContext context, final dynamic message) async {
    final driverLocation = DriverLocation.fromJSON(message);
    if (_isFirstRequest) {
      final childProvider = Provider.of<ChildProvider>(context, listen: false);
      _isFirstRequest = false;
      await _childService.setAllChildren(childProvider);
    }
    if (!driverLocation.isDriving) {
      _isFirstRequest = true;
    }
    final ChildProvider childProvider = Provider.of<ChildProvider>(context);
    await _childService.setAllChildren(childProvider);

    driverProvider.driverLocation = driverLocation;
  }

  static String _buildSendEventMessage(final LocationData locationData) =>
    '${SocketEvents.convertEnum(SocketEventsEnum.SEND_LOCATION)}/${_userProvider.user.userId}';

  static String _buildListeningEventMessage(final int driverId) =>
    '/topic/location/$driverId';
}

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:laravel_echo/laravel_echo.dart';

import '../environments/environment.dart';
import './socket_events.dart';

class WebSocket {
  final Echo _echo;

  WebSocket.driverPosition():
    _echo = Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'host': Environment.SOCKET_URL_DRIVER,
    });

  WebSocket.chat():
    _echo = Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'host': Environment.SOCKET_URL_CHAT,
    });


  void sendMessage(final SocketEventsEnum value, final String msg){
    final event = SocketEvents.convertEnum(value);
    _socket.emit(event, msg);
  }

  void listenMessage(final Function handler, {final SocketEventsEnum event, final String customEvent}) {
    String eventConverted;
    if (event != null ) {
      eventConverted = SocketEvents.convertEnum(event);
    } else if (customEvent != null) {
      eventConverted = customEvent;
    } else {
      eventConverted = 'default-event';
    }

    print('EVENT NAME -> \t$eventConverted');
    _socket.on(eventConverted, handler);
  }

  void disconnect() {
    _socket.clearListeners();
    _echo.disconnect();
  }

  IO.Socket get _socket => _echo.socket;
}

import 'package:stomp/stomp.dart';

import '../socket/web_socket.dart';
import '../socket/socket_exception.dart';
import '../socket/socket_events.dart';

import '../models/chat.dart';
import '../environments/environment.dart';

class SocketChatService {
  static StompClient _stomp;
  static WebSocket _webSocket;

  static Future<void> init() async {
    if (isConnected(false)) return;
    _webSocket = WebSocket();
    _stomp = await _webSocket.connect(Environment.SOCKET);
  }

  static void sendMessage(final int chatId, final ChatMessage chatMessage) {
    isDisconnected();
    final chatMap = ChatMessage.toJSON(chatMessage);
    final chatEndpoint = '${SocketEvents.convertEnum(SocketEventsEnum.SEND_MSG)}/$chatId';
    _stomp.sendJson(chatEndpoint, chatMap);
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
}

import './socket_exception.dart';

enum SocketEventsEnum { SHARING_LOCATION, SEND_MSG_CHAT, }

class SocketEvents {
  static const String SHARING_LOCATION = 'sharing-location';
  static const String SEND_MSG_CHAT = 'send-msg-chat';

  static String convertEnum(final SocketEventsEnum value) {
    switch (value) {
      case SocketEventsEnum.SEND_MSG_CHAT:
        return SEND_MSG_CHAT;
      case SocketEventsEnum.SHARING_LOCATION:
        return SHARING_LOCATION;
      default:
        throw SocketException('Nenhum evento encontrado com valor: $value');
    }
  }
}


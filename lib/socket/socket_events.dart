import './socket_exception.dart';

enum SocketEventsEnum { SEND_LOCATION, SEND_MSG, LISTING_MSG }

class SocketEvents {
  static const String SEND_LOCATION = '/api/location';
  static const String SEND_MSG = '/api/chat/sendMessage';
  static const String LISTING_MSG = '/topic/chat';

  static String convertEnum(final SocketEventsEnum value) {
    switch (value) {
      case SocketEventsEnum.SEND_LOCATION:
        return SEND_LOCATION;
      case SocketEventsEnum.SEND_MSG:
        return SEND_MSG;
      case SocketEventsEnum.LISTING_MSG:
        return LISTING_MSG;
      default:
        throw SocketException('Nenhum evento encontrado com valor: $value');
    }
  }
}


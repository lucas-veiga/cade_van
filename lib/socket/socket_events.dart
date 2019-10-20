import './socket_exception.dart';

enum SocketEventsEnum { SEND_LOCATION }

class SocketEvents {
  static const String SEND_LOCATION = '/api/location';

  static String convertEnum(final SocketEventsEnum value) {
    switch (value) {
      case SocketEventsEnum.SEND_LOCATION:
        return SEND_LOCATION;
      default:
        throw SocketException('Nenhum evento encontrado com valor: $value');
    }
  }
}


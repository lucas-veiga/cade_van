import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import '../models/chat.dart';
import './resource_exception.dart';

class ChatResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/chat';

  final Dio _dio = DioConfig.withInterceptors();

  static const String DEFAULT_MESSAGE = 'Error ao ';

  Future<Chat> findAllMessages(final int driverId, final int responsibleId) async {
    final url = '$RESOURCE_URL';
    final params = {'driverId': driverId, 'responsibleId': responsibleId};
    print('GET Request to $url | Params: $params');

    try {
      final res = await _dio.get(url, queryParameters: params);
      return Chat.fromJSON(res.data);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar a lista de convercaas', err);
    }
  }

  Future<List<int>> findAllChatIds() async {
    final url = '$RESOURCE_URL/user';
    print('GET Request to $url');

    try {
      final res = await _dio.get(url);
      return List<int>.from(res.data);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar a lista de chats', err);
    }
  }
}

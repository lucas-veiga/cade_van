import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';

class ChatResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/chat';

  final Dio _dio = DioConfig.withInterceptors();
}

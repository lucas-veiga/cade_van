import 'package:dio/dio.dart';

import '../models/user.dart';
import '../environments/environment.dart';
import '../config/dio_config.dart';

class ResponsibleResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/responsible';
  final Dio _dio = DioConfig.withInterceptors();

  Future<User> getResponsible(final String email) async {
      final res = await _dio.get('$RESOURCE_URL/email/$email');
      return User.fromJSON(res.data, UserTypeEnum.RESPONSIBLE);
  }
}

import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import '../models/user.dart';
import './resource_exception.dart';

class DriverResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/driver';

  final Dio _dio = DioConfig.withInterceptors();

  Future<User> findResponsibleDriver(final int responsibleId, final int driverId) async {
      try {
        final url = '$RESOURCE_URL/my-drivers/$responsibleId/$driverId';
        print('GET Request to $url');

        final res = await _dio.get(url);
        final user =  User.fromJSON(res.data);
        return user..type = UserTypeEnum.DRIVER;
      } on DioError catch(err) {
        throw ResourceException('Error ao pegar seus motoristas', err);
      }
  }
}

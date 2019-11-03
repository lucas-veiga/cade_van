import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import './resource_exception.dart';
import '../environments/environment.dart';
import '../models/user.dart';

class ResponsibleResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/responsible';
  static const String DEFAULT_MESSAGE = 'Error ao ';

  final Dio _dio = DioConfig.withInterceptors();

  Future<List<User>> getMyDrivers() async {
    try {
      final url = '$RESOURCE_URL/my-drivers';
      print('GET Requesto to $url');

      final res = await _dio.get(url);
      final untypedList = res.data.map((item) => User.fromJSON(item)).toList();
      final drivers = List<User>.from(untypedList);
      return drivers.map((item) => item..type = UserTypeEnum.DRIVER).toList();
    } on DioError catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar seus motoristas', err);
    }
  }
}

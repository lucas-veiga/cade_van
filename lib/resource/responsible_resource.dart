import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import './resource_exception.dart';
import '../environments/environment.dart';
import '../models/user.dart';

class ResponsibleResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/responsible';

  final Dio _dio = DioConfig.withInterceptors();

  Future<List<User>> getMyDrivers() async {
    try {
      final url = '$RESOURCE_URL/my-drivers';
      print('GET Requesto to $url');

      final res = await _dio.get(url);
      final untypedList = res.data.map((item) => User.fromJSON(item)).toList();
      final drivers = List<User>.from(untypedList);
      return drivers.map((item) => item..type = UserTypeEnum.DRIVER).toList();
    } on DioError catch (err) {
      throw ResourceException('Error ao pegar seus motoristas', err);
    }
  }
}

import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../models/user.dart';
import '../models/token.dart';

import '../config/dio_config.dart';
import './resource_exception.dart';
import '../environments/environment.dart';

class AuthResource {
  static const String resourceUrl = '${Environment.API_URL}';
  static const String auth = 'http://localhost:8080';

  final Dio _dio = DioConfig.dioDefault();

  Future<Token> login(final User user) async {
    final map = {
      'login': user.email,
      'password': user.password,
    };

    try {
      final userJson = json.encode(map);
      final res = await _dio.post('$auth/login', data: userJson);
      final token = res.headers.value('authorization');
      return Token.fromJSON(token);
    } on DioError catch(err, stack) {
      if (err.response == null) {
        Catcher.reportCheckedError(err, stack);
        throw ResourceException('Error ao pegar response do login', err);
      } else if (err.response.statusCode == 400) {
        throw new ResourceException(err.error);
      } else {
        Catcher.reportCheckedError(err, stack);
        throw ResourceException('Error ao realizar requisição do login', err);
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('Error ao realizar login', err);
    }
  }
}

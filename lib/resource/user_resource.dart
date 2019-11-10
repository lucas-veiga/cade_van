import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../models/user.dart';
import '../environments/environment.dart';
import '../config/dio_config.dart';
import './resource_exception.dart';

class UserResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/user';
  static const String DEFAULT_MESSAGE = 'Error ao ';

  final Dio _dioWithInterceptors = DioConfig.withInterceptors();
  final Dio _dio = DioConfig.dioDefault();

  Future<void> createUser(final User user) async {
    const String url = '$RESOURCE_URL/register';
    print('POST Request to $url');
    print('BODY: $user');

    try {
      final userMap = User.toJSON(user);
      final userJson = json.encode(userMap);
      await _dio.post(url, data: userJson);
    } on DioError catch(err, stack) {
      if (err.response == null) {
        Catcher.reportCheckedError(err, stack);
        throw ResourceException('$DEFAULT_MESSAGE ao criar conta', err);
      }

      if (err.response.statusCode == 400) {
        throw ResourceException.fromServer(err);
      }

      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE realizar requet para criar conta', err);
    }
  }

  Future<void> saveDeviceToken(final Map<String, String> user) async {
    final url = '$RESOURCE_URL/device-token';
    print('POST Request to $url');

    try {
      await _dioWithInterceptors.post(url, data: json.encode(user));
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE salvar o token do aparelho', err);
    }
  }

  Future<User> getUser(final String email) async {
    try {
      final url = '$RESOURCE_URL/$email';
      print('GET Request to $url');

      final res = await _dioWithInterceptors.get(url);
      final user = User.fromJSON(res.data);
      return user;
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar usuario', err);
    }
  }

  Future<User> getUserLoggedIn() async {
    try {
      final url = '$RESOURCE_URL/user-loggedin';
      print('GET Request to $url');

      final res = await _dioWithInterceptors.get(url);
      return User.fromJSON(res.data);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar usuario', err);
    }
  }
}

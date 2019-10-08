import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/user.dart';
import '../environments/environment.dart';
import '../config/dio_config.dart';
import './resource_exception.dart';

class UserResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/user';

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
    } on DioError catch(err) {
      if (err.response == null) {
        throw ResourceException('Algo deu errado ao criar conta', err);
      } else if (err.response.statusCode == 400) {
        throw ResourceException(err.error, err);
      } else {
        throw ResourceException('Error ao realizar requet para criar conta', err);
      }
    } catch (err) {
      throw ResourceException('Error ao criar conta', err);
    }
  }

  Future<User> getUser(final String email) async {
      try {
        final url = '$RESOURCE_URL/$email';
        print('GET Request to $url');

        final res = await _dioWithInterceptors.get(url);
        return User.fromJSON(res.data);
      } on DioError catch(err) {
        throw ResourceException('Error ao pegar usuario', err);
      }
  }

  Future<User> getUserLoggedIn() async {
    try {
      final url = '$RESOURCE_URL/user-loggedin';
      print('GET Request to $url');

      final res = await _dioWithInterceptors.get(url);
      return User.fromJSON(res.data);
    } on DioError catch(err) {
      throw ResourceException('Error ao pegar usuario logado', err);
    }
  }
}

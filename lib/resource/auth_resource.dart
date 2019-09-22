import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/dio_config.dart';
import '../utils/apit.dart';
import '../models/user.dart';

class AuthResource {
  static final String resourceUrl = '${API.API_URL}';
  static final String auth = 'http://localhost:8080';
  final Dio _dio = Dio();

  Future<void> createUser(final User user) {
    final userMap = User.toJSON(user);
    final userJson = json.encode(userMap);
    return _dio.post('$resourceUrl/register', data: userJson);
  }

  Future<String> login(final User user) {
    final map = {
      'login': user.email,
      'password': user.password,
    };

    final userJson = json.encode(map);
    return _dio.post('$auth/login', data: userJson)
      .then((res) => res.headers['authorization'].first);
  }
}

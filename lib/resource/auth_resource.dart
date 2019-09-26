import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth_service.dart';
import '../config/dio_config.dart';
import '../models/user.dart';
import './resource_exception.dart';
import '../utils/apit.dart';

class AuthResource {
  static final String resourceUrl = '${API.API_URL}';
  static final String auth = 'http://localhost:8080';

  final AuthService _authService = AuthService();
  final Dio _dio = DioConfig.dioDefault();

  Future<void> createUser(final User user) async {
    try {
      final userMap = User.toJSON(user);
      final userJson = json.encode(userMap);
      await _dio.post('$resourceUrl/register', data: userJson);
    } on DioError catch(err, stack) {
      if (err.response == null) {
        Catcher.reportCheckedError(err, stack);
        throw err;
      } else if (err.response.statusCode == 400) {
        throw new ResourceException(err.error);
      } else {
        Catcher.reportCheckedError(err, stack);
        throw err;
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw err;
    }
  }

  Future<void> login(final User user, final BuildContext context) async {
    final map = {
      'login': user.email,
      'password': user.password,
    };

    try {
      final userJson = json.encode(map);
      final res = await _dio.post('$auth/login', data: userJson);
      final token = res.headers.value('authorization');
      _authService.login(token, context);
    } on DioError catch(err, stack) {
      if (err.response == null) {
        Catcher.reportCheckedError(err, stack);
        throw err;
      } else if (err.response.statusCode == 400) {
        throw new ResourceException(err.error);
      } else {
        Catcher.reportCheckedError(err, stack);
        throw err;
      }
    } catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw err;
    }
  }
}
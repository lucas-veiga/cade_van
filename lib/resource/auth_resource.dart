import 'dart:convert';

import 'package:cade_van/provider/user_provider.dart';
import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../config/dio_config.dart';
import '../models/user.dart';
import './resource_exception.dart';
import '../environments/environment.dart';
import '../services/responsible_service.dart';

class AuthResource {
  static final String resourceUrl = '${Environment.API_URL}';
  static final String auth = 'http://localhost:8080';

  final AuthService _authService = AuthService();
  final Dio _dio = DioConfig.dioDefault();
  final ResponsibleService _responsibleService = ResponsibleService();

  Future<void> createUser(final User user) async {
    print('POST Request to $resourceUrl');
    print('BODY: $user');
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
      final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final userJson = json.encode(map);
      final res = await _dio.post('$auth/login', data: userJson);
      final token = res.headers.value('authorization');

      await _authService.login(token, context);
      await _responsibleService.setCurrentUser(userProvider);
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

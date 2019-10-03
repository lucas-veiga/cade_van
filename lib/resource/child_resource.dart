import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/child.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';

class ChildResource {
  static final String resourceUrl = '${Environment.API_URL}/child';

  final Dio _dio = DioConfig.withInterceptors();

  Future<Child> saveChild(final Child child) async {
    final res = await _dio.post(resourceUrl, data: json.encode(Child.toJSON(child)));
    return Child.fromJSON(res.data);
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/child.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';

class ChildResource {
  static final String resourceUrl = '${Environment.API_URL}/child';

  final Dio _dio = DioConfig.withInterceptors();

  Future<void> saveChild(final Child child) async {
    print('POST Request to $resourceUrl');
    print('BODY: $child');
    await _dio.post(resourceUrl, data: json.encode(Child.toJSON(child)));
  }

  Future<List<Child>> getAllChildren() async {
    print('GET Request to $resourceUrl');
    final res = await _dio.get(resourceUrl);
    final untypedList =  res.data.map((item) => Child.fromJSON(item)).toList();
    return List<Child>.from(untypedList);
  }
}

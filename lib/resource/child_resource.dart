import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/child.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import './resource_exception.dart';

class ChildResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/child';

  final Dio _dio = DioConfig.withInterceptors();

  Future<void> saveChild(final Child child) async {
    try {
      print('POST Request to $RESOURCE_URL');
      print('BODY: $child');
      await _dio.post(RESOURCE_URL, data: json.encode(Child.toJSON(child)));
    } on DioError catch (err) {
      throw ResourceException('Error ao criar crianca', err);
    }
  }

  Future<List<Child>> getAllChildren() async {
    try {
      print('GET Request to $RESOURCE_URL');
      final res = await _dio.get(RESOURCE_URL);
      final untypedList =  res.data.map((item) => Child.fromJSON(item)).toList();
      return List<Child>.from(untypedList);
    } on DioError catch (err) {
      throw ResourceException('Error ao pegar criancas', err);
    }
  }

  Future<void> updateStatusWaiting(final int itineraryId) async {
    try {
      final url = '$RESOURCE_URL/itinerary/$itineraryId';
      print('GET Request to $url');
      await _dio.get(url);
    } on DioError catch (err) {
      throw ResourceException('Error ao pegar criancas', err);
    }
  }
}

import 'dart:convert';

import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../models/child.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import './resource_exception.dart';

class ChildResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/child';
  static const String DEFAULT_MESSAGE = 'Error ao ';

  final Dio _dio = DioConfig.withInterceptors();

  Future<void> saveChild(final Child child) async {
    try {
      print('POST Request to $RESOURCE_URL');
      print('BODY: $child');
      await _dio.post(RESOURCE_URL, data: json.encode(Child.toJSON(child)));
    } on DioError catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE criar a criança', err);
    }
  }

  Future<List<Child>> getAllChildren() async {
    try {
      print('GET Request to $RESOURCE_URL');
      final res = await _dio.get(RESOURCE_URL);
      final untypedList =  res.data.map((item) => Child.fromJSON(item)).toList();
      return List<Child>.from(untypedList);
    } on DioError catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar todas as criancas', err);
    }
  }

  Future<void> updateStatusWaiting(final int itineraryId) async {
    try {
      final url = '$RESOURCE_URL/itinerary/$itineraryId';
      print('GET Request to $url');
      await _dio.get(url);
    } on DioError catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE atualzar status da crianca', err);
    }
  }

  Future<Child> updateChild(final Child child) async {
    try {
      print('PUT Request to $RESOURCE_URL');
      final childJSON = json.encode(Child.toJSON(child));
      final res = await _dio.put(RESOURCE_URL, data: childJSON);
      return Child.fromJSON(res.data);
    } on DioError catch (err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE atualizar crianca', err);
    }
  }
}

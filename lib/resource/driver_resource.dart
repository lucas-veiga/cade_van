import 'package:catcher/core/catcher.dart';
import 'package:dio/dio.dart';

import '../models/itinerary.dart';
import '../models/child.dart';

import '../config/dio_config.dart';
import '../environments/environment.dart';
import './resource_exception.dart';

class DriverResource {
  static const String RESOURCE_URL = '${Environment.API_URL}/driver';
  static const String ITINERARY_RESOURCE = '${Environment.API_URL}/itinerary';
  static const String DEFAULT_MESSAGE = 'Error ao ';

  final Dio _dio = DioConfig.withInterceptors();

  Future<List<Child>> findMyChildren() async {
    try {
      final url = '$RESOURCE_URL/children';
      print('GET Request to $url');

      final res = await _dio.get(url);
      final untypedList = res.data.map((item) => Child.fromJSON(item)).toList();
      final children = List<Child>.from(untypedList);
      print('Response: \t$children');
      return children;
    } on DioError catch(err, stack) {
        Catcher.reportCheckedError(err, stack);
        throw ResourceException('$DEFAULT_MESSAGE pegar suas criancas', err);
    }
  }

  Future<void> saveItinerary(final String itineraryJSON) async {
    try {
      print('POST Request to $ITINERARY_RESOURCE');
      print('Body: \t$itineraryJSON');
      await _dio.post(ITINERARY_RESOURCE, data: itineraryJSON);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE salvar intinerario', err);
    }
  }

  Future<void> initItinerary(final int itineraryId) async {
    try {
      final url = '$ITINERARY_RESOURCE/init/$itineraryId';
      print('GET Request to $url');

      await _dio.get(url);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE iniciar itinerario | ItineraryId: $itineraryId', err);
    }
  }

  Future<void> finishItinerary(final int itineraryId) async {
    try {
      final url = '$ITINERARY_RESOURCE/finish/$itineraryId';
      print('GET Request to $url');

      await _dio.get(url);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE finalizar itinerario | ItineraryId: $itineraryId', err);
    }
  }

  Future<List<Itinerary>> findAll() async {
    try {
      print('GET Request to $ITINERARY_RESOURCE');

      final res = await _dio.get(ITINERARY_RESOURCE);
      final untypedList = res.data.map((item) => Itinerary.fromJSON(item)).toList();
      final list = List<Itinerary>.from(untypedList);
      print('Response: \t$list');
      return list;
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar todos intinerarios', err);
    }
  }

  Future<Itinerary> findItinerary(final int itineraryId) async {
    try {
      final url = '$RESOURCE_URL/$itineraryId';
      print('GET Request to $url');

      final res = await _dio.get(url);
      return Itinerary.fromJSON(res.data);
    } on DioError catch(err, stack) {
      Catcher.reportCheckedError(err, stack);
      throw ResourceException('$DEFAULT_MESSAGE pegar intinerario com id $itineraryId', err);
    }
  }
}

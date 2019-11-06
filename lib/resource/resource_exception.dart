import 'package:dio/dio.dart';

class ResourceException implements Exception {
  final String msg;
  final dynamic err;

  ResourceException(this.msg,  [ this.err ]);

  ResourceException.fromServer(final DioError error, [ this.err ]):
    msg = error.response.data['message'];

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write('ResourceException: { ');

    if (err is DioError) {
      if (err.request != null &&
        err.request.uri != null) {
        buffer.write('URL: "${err.request.uri.toString()}", ');
      } else {
        buffer.write('URL: null, ');
      }
      buffer.write('error: "${err.error}", ');
      buffer.write('message: "${err.message}", ');
      if (err.response != null && err.response.data != null) {
        buffer.write('data: "${err.response.data}", ');
        buffer.write('statusCode: "${err.response.statusCode}", ');
        buffer.write('statusMessage: "${err.response.statusMessage}",');
        buffer.write('headers: "${err.response.headers}, "');
      } else {
        buffer.write('response: null, ');
      }
    } else {
      buffer.write('isNotDioError: true, ');
    }
    buffer.write('customMessage: "$msg", ');
    buffer.write('error: "$err"');
    buffer.write(' }');
    return buffer.toString();
  }
}

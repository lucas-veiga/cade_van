import 'package:dio/dio.dart';
import '../utils/token.dart';

class DioConfig extends Dio {
  static final TokenUtil _tokenUtil = TokenUtil();

  static Dio withInterceptors() =>
    Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options) async {
            final token = await _tokenUtil.getToken();
            options.headers.addAll({'Authorization': 'Bearer ${token.jwtEncoded}'});
          }
        ),
      );

  static Dio dioDefault() =>
    Dio();
}

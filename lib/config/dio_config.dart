import 'package:dio/dio.dart';

class DioConfig extends Dio {
   factory DioConfig() {
     return Dio()
     ..interceptors.add(
       InterceptorsWrapper(
         onRequest: (RequestOptions options) async {
           options.headers.addAll({'Authorization': 'Bearer NAO TEM AINDA'});
         }
       ),
     );
   }
}

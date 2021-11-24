import 'package:dio/dio.dart';

class Client {
  Dio init() {
    Dio _dio = Dio();
    _dio.options.baseUrl = "https://dev-basic.api.ffw.io/v6/";

    return _dio;
  }
}
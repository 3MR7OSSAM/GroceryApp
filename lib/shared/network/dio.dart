
import 'package:dio/dio.dart';

class DioHelperPayment {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://accept.paymob.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData(
      {required String url, Map<String, dynamic>? query}) async {
    dio.options.headers = {
      'content-type': 'application/json',
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url,Map<String, dynamic>?data ,  Map<String, dynamic>? query}) async {
    dio.options.headers = {
      'content-type': 'application/json',
    };
    return await dio.post(url,data: data,  queryParameters: query);
  }
}

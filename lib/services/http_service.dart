/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:37:09
 * @LastEditTime: 2022-04-15 14:34:55
 * @FilePath: \flutter_easymusic\lib\services\http_service.dart
 */
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter_easymusic/api/config/http_config.dart';
import 'package:get/get.dart';


class HttpService extends GetxService {

  late final Dio _dio;

  Future<Dio> init() async {
    _dio = Dio();
    //解决证书问题
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };//dio 配置
    _dio.options.baseUrl = HttpConfig.baseUrl; //baseUrl
    _dio.options.connectTimeout = HttpConfig.connectTimeout; //超时时间
    _dio.options.receiveTimeout = HttpConfig.receiveTimeout; //接收数据最长时间
    _dio.options.responseType = ResponseType.json; //数据格式
    if (HttpConfig.logged) {
      _dio.interceptors.add(LogInterceptor(requestBody: true)); //日志拦截器
    }
    return _dio;
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
} 

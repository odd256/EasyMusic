import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//单例模式
class HttpManager {
  Dio? _dio;
  static HttpManager _instance = HttpManager._internal();

  factory HttpManager() => _instance;

  static const codeSuccess = 200;

  //第一次使用初始化
  HttpManager._internal() {
    _dio ??= _init();
  }

  static HttpManager getInstance({String? baseUrl}) {
    if (baseUrl == null) {
      _instance = HttpManager._internal();
      _instance._init();
    }
    return _instance;
  }

  _init({String? baseUrl}) {
    Dio dio = Dio();
    //解决证书问题
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
    };
    //dio 配置
    dio.options.baseUrl = baseUrl ??
        "https://netease-cloud-music-api-mr-odd.vercel.app"; //baseUrl
    dio.options.connectTimeout = 7000; //超时时间
    dio.options.receiveTimeout = 3000; //接收数据最长时间
    dio.options.responseType = ResponseType.json; //数据格式
    return dio;
  }

  get(url, {params, withLoading = true, withSuccess=false}) async {
    if (withLoading) EasyLoading.show(status: 'loading...');
    Response? response;
    try{
      response = await _dio?.get(url, queryParameters: params);
      if(withSuccess){
        EasyLoading.showSuccess('success');
      }
    }on DioError catch(e){
        print(e);
    }
    EasyLoading.dismiss();
    return response?.data;
  }
}

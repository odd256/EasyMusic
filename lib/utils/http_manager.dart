import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//单例模式
class HttpManager {
  Dio? _dio;
  static HttpManager _instance = HttpManager._internal();

  factory HttpManager() => _instance;

  //第一次使用初始化
  HttpManager._internal() {
    _init();
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
    _dio = dio;
  }

  get(url,
      {params, withLoading = false, withSuccess = false, cancelToken}) async {
    if (withLoading) EasyLoading.show();
    Response? response;
    try {
      response = await _dio?.get(url,
          queryParameters: params, cancelToken: cancelToken);
      if (withSuccess) {
        EasyLoading.showSuccess('Success');
      }
    } on DioError catch (e) {
      print(e);
    }
    EasyLoading.dismiss();
    return response?.data;
  }

  cancelRequest(CancelToken token, {msg = 'disposed page'}) {
    token.cancel(msg);
  }
}

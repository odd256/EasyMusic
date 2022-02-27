/*
 * @Creator: Odd
 * @Date: 2022-02-05 05:08:38
 * @LastEditTime: 2022-02-28 02:13:57
 * @FilePath: \flutter_music_player\lib\utils\http_manager.dart
 */
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_music_player/utils/msg_util.dart';

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
      return null;
    };
    //dio 配置
    dio.options.baseUrl = baseUrl ??
        "https://netease-cloud-music-api-mr-odd.vercel.app"; //baseUrl
    dio.options.connectTimeout = 7000; //超时时间
    dio.options.receiveTimeout = 3000; //接收数据最长时间
    dio.options.responseType = ResponseType.json; //数据格式
    // dio.interceptors.add(LogInterceptor(requestBody: true)); //日志拦截器
    dio.interceptors.add(CustomDioInterceptor()); //自定义拦截器
    _dio = dio;
  }

  get(url,
      {params, withLoading = false, withSuccess = false, cancelToken}) async {
    if (withLoading) EasyLoading.show();
    Response? response;

    response =
        await _dio?.get(url, queryParameters: params, cancelToken: cancelToken);
    if (withSuccess) {
      EasyLoading.showSuccess('Success');
    }

    EasyLoading.dismiss();
    return response?.data;
  }

  cancelRequest(CancelToken token, {msg = 'disposed page'}) {
    token.cancel(msg);
  }
}

class CustomDioInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    switch (err.type) {
      case DioErrorType.connectTimeout:
        // TODO: Handle this case.
        MsgUtil.warn(msg: '网络连接超时');
        break;
      case DioErrorType.sendTimeout:
        // TODO: Handle this case.
        MsgUtil.warn(msg: '网络请求超时');
        break;
      case DioErrorType.receiveTimeout:
        // TODO: Handle this case.
        MsgUtil.warn(msg: '网络接收超时');
        break;
      case DioErrorType.response:
        // TODO: Handle this case.
        MsgUtil.warn(msg: '网络请求失败');
        break;
      case DioErrorType.cancel:
        // TODO: Handle this case.
        // MsgUtil.warn(msg: '网络请求取消');
        break;
      case DioErrorType.other:
        // TODO: Handle this case.
        MsgUtil.warn(msg: '网络请求失败');
        break;
    }
  }
}

/*
 * @Creator: Odd
 * @Date: 2022-04-12 16:37:26
 * @LastEditTime: 2022-08-01 01:18:44
 * @FilePath: \EasyMusic\lib\api\user_api.dart
 */
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserApi {
  static final dio = Get.find<Dio>();
  //登录
  static login(String phone, String captcha) async {
    var res = await dio.get('/login/cellphone?phone=$phone&captcha=$captcha');
    return res.data;
  }

  //请求手机验证码
  static sendCapcha(String phone) async {
    var res = await dio.get('/captcha/sent?phone=$phone');
    return res.data;
  }

  //查看登陆状态
  static checkLoginStatus(String cookie) async {
    var res = await dio.get('/login/status?cookie=$cookie');
    return res.data;
  }

  static logout() async {
    var res = await dio.get('/logout');
    return res.data;
  }
}

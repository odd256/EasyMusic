/*
 * @Creator: Odd
 * @Date: 2022-04-12 16:37:26
 * @LastEditTime: 2022-08-14 01:52:45
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

  //请求二维码key
  static getQRCodeKey() async {
    var res = await dio.get(
        '/login/qr/key?timerstamp=${DateTime.now().millisecondsSinceEpoch}');
    return res.data;
  }

  //请求二维码图片
  static getQRCode(String key) async {
    var res = await dio.get(
        '/login/qr/create?key=$key&qrimg=ture&timerstamp=${DateTime.now().millisecondsSinceEpoch}');
    return res.data;
  }

  //查看二维码状态
  static checkQRCodeStatus(key) async {
    print(
        '/login/qr/check?key=$key&timerstamp=${DateTime.now().millisecondsSinceEpoch}');
    var res = await dio.get(
        '/login/qr/check?key=$key&timerstamp=${DateTime.now().millisecondsSinceEpoch}');
    return res.data;
  }
}

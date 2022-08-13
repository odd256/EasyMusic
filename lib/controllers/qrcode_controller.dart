/*
 * @Creator: Odd
 * @Date: 2022-08-14 00:48:28
 * @LastEditTime: 2022-08-14 02:31:05
 * @FilePath: \EasyMusic\lib\controllers\qrcode_controller.dart
 */
import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easymusic/api/user_api.dart';
import 'package:flutter_easymusic/models/user.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:flutter_easymusic/utils/msg_util.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QRCodeController extends GetxController {
  final qrcode = ''.obs;
  final userState = Get.find<UserState>();
  final box = GetStorage();
  String key = '';

  final qrStatus = 0.obs;

  late Timer _timer;

  //获取二维码
  getQRCode() async {
    //获取key
    var data = await UserApi.getQRCodeKey();
    key = data['data']['unikey'];
    //获取二维码
    var d = await UserApi.getQRCode(key);
    //返回是一个Base64的编码
    qrcode.value = d['data']['qrimg'];

    //开始计时
    _timer = Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      checkStatus();
    });
  }

  //检查二维码状态
  checkStatus() async {
    var res = await UserApi.checkQRCodeStatus(key);
    qrStatus.value = res['code'];
    if (res['code'] == 800 || res['code'] == 803) {
      _timer.cancel(); //停止计时
      if (res['code'] == 803) {
        //使用cookie请求用户数据
        var d = await UserApi.checkLoginStatus(res['cookie']);
        User u = User.fromLoginStatusJson(d['data'], res['cookie']);
        // userState.user.value = u;
        await box.write('user', u); //持久化
        userState.isLogin.value = true;
        //回到启动页
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}

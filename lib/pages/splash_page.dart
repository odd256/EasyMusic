/*
 * @Creator: Odd
 * @Date: 2022-04-12 16:40:05
 * @LastEditTime: 2022-07-25 02:07:16
 * @FilePath: \flutter_easymusic\lib\pages\splash_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/api/user_api.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:flutter_easymusic/models/user.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/msg_util.dart';

///闪屏页
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final box = GetStorage();

    final userState = Get.find<UserState>();

    //当widget加载完后，再进行登录判断
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //自动登录
      var d = box.read('user');
      if (d != null) {
        User u = User.fromBox(box.read('user'));
        //检查cookie是否过期
        var data = await UserApi.checkLoginStatus(u.cookie);
        if (data['data']['code'] == 200) {
          //验证成功
          userState.user.value = u;
          userState.isLogin.value = true;
          Get.offAllNamed(AppRoutes.home);
        } else {
          //验证失败
          await box.remove('user');
          MsgUtil.warn('请重新登录');
          Get.offAllNamed('/login');
        }
      } else {
        MsgUtil.notice('请登录');
        Get.offAllNamed('/login');
      }
    });
    return Container(
      color: Colors.blue,
      child: const Center(
        child: FlutterLogo(
          size: 250,
          textColor: Colors.white,
          duration: Duration(milliseconds: 3000),
          style: FlutterLogoStyle.horizontal,
          curve: Curves.bounceIn,
        ),
      ),
    );
  }
}

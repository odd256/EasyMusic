/*
 * @Creator: Odd
 * @Date: 2022-04-12 16:40:05
 * @LastEditTime: 2022-04-13 16:11:19
 * @FilePath: \flutter_easymusic\lib\pages\splash_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:get/get.dart';

///闪屏页
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //当widget加载完后，再进行登录判断
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Get.find<UserController>().autoLogin();
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

/*
 * @Creator: Odd
 * @Date: 2022-08-13 23:10:57
 * @LastEditTime: 2022-08-14 00:12:14
 * @FilePath: \EasyMusic\lib\pages\login\login_choose_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/pages/login/login_phone_page.dart';
import 'package:flutter_easymusic/pages/login/login_qrcode_page.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:get/get.dart';

class LoginChoosePage extends StatelessWidget {
  const LoginChoosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: const TextTheme(button: TextStyle(fontSize: 19))),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '请选择登录方式',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.loginPhone),
                  child: const Text('手机登录')),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.loginQRCode),
                  child: const Text('扫码登录'))
            ],
          ),
        ),
      ),
    );
  }
}

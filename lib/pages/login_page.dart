/*
 * @Creator: Odd
 * @Date: 2022-04-12 20:17:42
 * @LastEditTime: 2022-04-19 11:09:59
 * @FilePath: \flutter_easymusic\lib\pages\login_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '手机号登录',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() => _userController.hasSend.value
          ? const CaptchaLoginPage()
          : const LoginPhonePage()),
    );
  }
}

class LoginPhonePage extends StatelessWidget {

  const LoginPhonePage(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: const Text(
              '登录体验内容',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text('目前仅支持手机登录，后续将开放更多的登录方式，主要是api的适配没有太多精力了~')),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_android_rounded), labelText: '手机号'),
          keyboardType: TextInputType.phone,
          controller: userController.pc,
          autofocus: true,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                onPressed: userController.ready2Send.value
                    ? () {
                        userController.sendCaptcha();
                      }
                    : null,
                child: Text(userController.ready2Send.value
                    ? '发送验证码'
                    : userController.timeCounter.value.toString()))))
      ],
    );
  }
}

class CaptchaLoginPage extends StatelessWidget {
  const CaptchaLoginPage(
       {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: const Text(
              '请输入验证码',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                '已发送至+86 ${userController.pc.text.replaceRange(userController.pc.text.length < 3 ? userController.pc.text.length : 3, userController.pc.text.length < 7 ? userController.pc.text.length : 7, '****')}'),
                            IconButton(
                                onPressed: () =>
                                    userController.hasSend.value = false,
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  size: 16,
                                )),
                          ],
                        ),
                        TextButton(
                            onPressed: userController.ready2Send.value
                                ? () => userController
                                    .sendCaptcha()
                                : null,
                            child: Text(userController.ready2Send.value
                                ? '重新发送'
                                : userController.timeCounter.value.toString()))
                      ]))),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.check_circle_rounded), labelText: '验证码'),
          keyboardType: TextInputType.number,
          controller: userController.cc,
          autofocus: true,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => userController.login(),
                child: const Text('登录')))
      ],
    );
  }
}

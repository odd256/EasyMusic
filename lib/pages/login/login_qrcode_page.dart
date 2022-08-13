/*
 * @Creator: Odd
 * @Date: 2022-08-13 23:20:53
 * @LastEditTime: 2022-08-14 01:40:59
 * @FilePath: \EasyMusic\lib\pages\login\login_qrcode_page.dart
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/qrcode_controller.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:flutter_easymusic/utils/msg_util.dart';
import 'package:get/get.dart';

class LoginQRCodePage extends StatelessWidget {
  const LoginQRCodePage({Key? key}) : super(key: key);

  Widget buildHintText(int code) {
    final QRCodeController qrCodeController = Get.find<QRCodeController>();
    switch (code) {
      case 0:
        {
          //初始状态
          return const Text('');
        }
      case 800:
        {
          MsgUtil.warn('二维码过期，请刷新');
          return TextButton(
            onPressed: () => qrCodeController.getQRCode(),
            child: const Text(
              '点我刷新',
            ),
          );
        }
      case 801:
        {
          return const Text('请扫码');
        }
      case 802:
        {
          MsgUtil.notice('待确认');
          return const Text('请稍等');
        }
      case 803:
        {
          MsgUtil.success('登录成功');
          return const Text('');
        }
      default:
        {
          MsgUtil.warn("出错了");
          return const Text('');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final QRCodeController qrCodeController = Get.find<QRCodeController>();
    qrCodeController.getQRCode();
    return Scaffold(
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '扫描二维码登录',
                  style: TextStyle(fontSize: 20),
                ),
                qrCodeController.qrcode.value.isEmpty
                    ? const CircularProgressIndicator()
                    : Image.memory(const Base64Decoder()
                        .convert(qrCodeController.qrcode.value.split(',')[1])),
                buildHintText(qrCodeController.qrStatus.value)
              ],
            ),
          )),
    );
  }
}

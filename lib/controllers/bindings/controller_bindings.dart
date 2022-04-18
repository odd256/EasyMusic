/*
 * @Creator: Odd
 * @Date: 2022-04-12 12:37:27
 * @LastEditTime: 2022-04-17 01:19:10
 * @FilePath: \flutter_easymusic\lib\controllers\bindings\controller_bindings.dart
 */
import 'package:dio/dio.dart';
import 'package:flutter_easymusic/services/http_service.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:get/get.dart';

///用于添加controller的依赖
class GlobalControllerBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(AudioController(), permanent: true);
  }
}

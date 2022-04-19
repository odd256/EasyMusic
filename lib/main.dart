/*
 * @Creator: Odd
 * @Date: 2022-04-11 18:07:24
 * @LastEditTime: 2022-04-19 02:23:34
 * @FilePath: \flutter_easymusic\lib\main.dart
 */
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/bindings/controller_bindings.dart';
import 'package:flutter_easymusic/pages/routes/app_pages.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:flutter_easymusic/services/audio_handler.dart';
import 'package:flutter_easymusic/services/http_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await initService();
  runApp(GetMaterialApp(
    initialBinding: GlobalControllerBinding(),
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.initPage,
    defaultTransition: Transition.fade,
    getPages: AppPages.routes,
  ));
}

initService() async {
  log('--------initService start--------');
  await Get.putAsync(() => initAudioService());
  await Get.putAsync(() => HttpService().init());
  await Get.putAsync(() => UserState().init());
  await Get.putAsync(() => PlaylistState().init());
  await GetStorage.init();
  log('--------initService done--------');
}

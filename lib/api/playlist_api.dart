/*
 * @Creator: Odd
 * @Date: 2022-04-13 18:13:20
 * @LastEditTime: 2022-04-13 20:28:35
 * @FilePath: \flutter_easymusic\lib\api\playlist_api.dart
 */
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PlaylistApi {
  static final dio = Get.find<Dio>();

  //获取我的歌单列表
  static getPlaylistByUid(num id) async {
    var res = await dio.get('/user/playlist?uid=$id');
    return res.data;
  }
}
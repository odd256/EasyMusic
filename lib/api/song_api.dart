/*
 * @Creator: Odd
 * @Date: 2022-04-14 20:47:38
 * @LastEditTime: 2022-04-14 20:51:37
 * @FilePath: \flutter_easymusic\lib\api\song_api.dart
 */
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SongApi {
  static final dio = Get.find<Dio>();

  //获取我的歌单列表
  static getMySongsByPlaylistId (num id, String cookie) async {
    var res = await dio.get('/playlist/detail?id=$id&cookie=$cookie');
    return res.data;
  }
}
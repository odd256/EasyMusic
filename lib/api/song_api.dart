/*
 * @Creator: Odd
 * @Date: 2022-04-14 20:47:38
 * @LastEditTime: 2022-07-26 14:41:10
 * @FilePath: \EasyMusic\lib\api\song_api.dart
 */
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SongApi {
  static final dio = Get.find<Dio>();

  //获取歌曲
  static getMySongsByPlaylistId (num id, String cookie) async {
    var res = await dio.get('/playlist/detail?id=$id&cookie=$cookie');
    return res.data;
  }

  //获取歌词
  static getLyricBySongId(String id) async {
    var res = await dio.get('/lyric?id=$id');
    return res.data;
  }

  //搜索歌曲
  static searchSongsWithPage(String keywords, int limit, int offset) async {
    var res = await dio.get('/cloudsearch?keywords=$keywords');
    return res.data;
  }
}
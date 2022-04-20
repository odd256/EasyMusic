/*
 * @Creator: Odd
 * @Date: 2022-04-13 18:15:27
 * @LastEditTime: 2022-04-20 16:22:46
 * @FilePath: \flutter_easymusic\lib\controllers\playlist_controller.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/api/playlist_api.dart';
import 'package:flutter_easymusic/models/creator.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {

  final onLoad = true.obs;

  final playlists = List<Playlist>.empty().obs;
  UserState userState = Get.find<UserState>();
  final scrollController = ScrollController();
  @override
  void onInit() {
    if (userState.isLogin.value) {
      getPlaylistByUid(userState.user.value.id);
    }
    super.onInit();
  }

  //获取用户歌单
  getPlaylistByUid(num id) async {
    //从网络获取
    var data = await PlaylistApi.getPlaylistByUid(id);
    playlists.value = data['playlist'].map<Playlist>((e) {
      Creator c = Creator.fromJson(e['creator']);
      return Playlist.fromJson(e, c);
    }).toList();
    onLoad.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

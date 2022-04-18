/*
 * @Creator: Odd
 * @Date: 2022-04-13 18:15:27
 * @LastEditTime: 2022-04-15 14:35:24
 * @FilePath: \flutter_easymusic\lib\controllers\playlist_controller.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/api/playlist_api.dart';
import 'package:flutter_easymusic/models/creator.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController {
  var playlists = List<Playlist>.empty().obs;
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
    // bool? isCached = SpUtil.haveKey('playList');

    // if (isCached == true) {
    //   //从本地缓存获取
    //   if (_playList.isEmpty) {
    //     //避免重复加载
    //     setState(() {
    //       _playList = SpUtil.getObjList<PlayList>('playList', (v) {
    //         return PlayList.fromJson(v, User.fromJson2(v['creator']));
    //       })!;
    //     });
    //   }
    // } else {
    //从网络获取
    var data = await PlaylistApi.getPlaylistByUid(id);
    // if (playlists.isEmpty) {
    //避免重复加载
    playlists.value = data['playlist'].map<Playlist>((e) {
      Creator c = Creator.fromJson(e['creator']);
      return Playlist.fromJson(e, c);
    }).toList();
    // }
    //放入本地缓存
    // await SpUtil.putObjectList('playList', _playList);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

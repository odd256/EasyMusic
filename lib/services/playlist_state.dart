/*
 * @Creator: Odd
 * @Date: 2022-04-14 22:14:50
 * @LastEditTime: 2022-06-25 16:09:27
 * @FilePath: \flutter_easymusic\lib\services\playlist_state.dart
 */
import 'package:audio_service/audio_service.dart';
import 'package:flutter_easymusic/models/creator.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:get/get.dart';

class PlaylistState extends GetxService {
  final currentPlaylist = Playlist(0, '', '', 0,
          Creator(userId: 0, nickname: '', avatarUrl: ''))
      .obs;

  final currentMediaItems = List<MediaItem>.empty().obs;

  Future<PlaylistState> init() async {
    return this;
  }
}

/*
 * @Creator: Odd
 * @Date: 2022-04-13 22:33:52
 * @LastEditTime: 2022-08-14 02:51:23
 * @FilePath: \EasyMusic\lib\controllers\playlist_songs_controller.dart
 */
import 'package:audio_service/audio_service.dart';
import 'package:flutter_easymusic/api/song_api.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/models/album.dart';
import 'package:flutter_easymusic/models/artist.dart';
import 'package:flutter_easymusic/models/creator.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/models/song.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:get/get.dart';

class PlaylistSongsController extends GetxController {
  final audioController = Get.find<AudioController>();
  final playlistState = Get.find<PlaylistState>();
  final audioHandler = Get.find<AudioHandler>();

  final onLoad = true.obs;

  @override
  void onInit() {
    getMySongsByPlaylist(playlistState.currentPlaylist.value);
    super.onInit();
  }

  void resetPlaylistState() {
    playlistState.currentPlaylist.value = Playlist(0, '', '', 0,
        Creator(userId: 0, nickname: '', avatarUrl: ''));
    playlistState.currentMediaItems.value = List<MediaItem>.empty();
  }

  void updatePlaylistState(p, m) {
    playlistState.currentPlaylist.value = p;
    playlistState.currentMediaItems.value = m;
  }

  void getMySongsByPlaylist(Playlist p) async {
    resetPlaylistState();
    var cookie = Get.find<UserState>().user.value.cookie;
    var data = await SongApi.getMySongsByPlaylistId(p.id, cookie);
    final mediaItems = data['playlist']['tracks'].map<MediaItem>((e) {
      final al = Album.fromJson(e['al']);
      final ar = e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
      final s = Song.fromJson(e, ar, al);
      //将歌曲信息添加到mediaItem中
      final m = MediaItem(
          id: s.id.toString(),
          title: s.name,
          album: s.album?.name,
          artist: ar.map((v) => v.name).join('/'),
          artUri: Uri.parse(s.album?.picUrl ?? ''),
          extras: {
            'url': 'https://music.163.com/song/media/outer/url?id=${s.id}.mp3'
          });
      // _audioHandler.addQueueItem(m);
      return m;
    }).toList();
    updatePlaylistState(p, mediaItems);
    onLoad.value = false;
  }

  // 点击播放音乐
  Future<void> onSonglistItemClick(Playlist p, int index) async {
    //当playlist的id与currentPlaylist的ID一致时，不用更新，直接播放音乐
    if (p.id == audioController.currentPlaylist.id) {
      await audioHandler.skipToQueueItem(index);
      await audioHandler.play();
    } else {
      //更新当前的歌单
      audioController.updatePlaylist(playlistState.currentPlaylist.value);
      await audioHandler.updateQueue(playlistState.currentMediaItems);
      await audioHandler.skipToQueueItem(index);
      await audioHandler.play();
    }
  }
}

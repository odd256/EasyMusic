/*
 * @Creator: Odd
 * @Date: 2022-04-13 22:33:52
 * @LastEditTime: 2022-04-19 01:02:09
 * @FilePath: \flutter_easymusic\lib\controllers\playlist_songs_controller.dart
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

const String defaultImgUrl =
    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F13633347286%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1652722376&t=dfc48d0e5d3cdf81ad0075013f89d710';

class PlaylistSongsController extends GetxController {
  // var mediaItems = List<MediaItem>.empty().obs;
  final audioController = Get.find<AudioController>();
  final playlistState = Get.find<PlaylistState>();
  final audioHandler = Get.find<AudioHandler>();
  // final playlist = Playlist(0, '', '', 0, Creator(userId: 0, nickname: '', avatarUrl: '')).obs;

  @override
  void onInit() {
    getMySongsByPlaylist(playlistState.currentPlaylist.value);
    super.onInit();
  }

  void resetPlaylistState() {
    playlistState.currentPlaylist.value = Playlist(0, defaultImgUrl, '', 0,
        Creator(userId: 0, nickname: '', avatarUrl: defaultImgUrl));
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
          extras: {
            'url': 'https://music.163.com/song/media/outer/url?id=${s.id}.mp3'
          });
      // _audioHandler.addQueueItem(m);
      return m;
    }).toList();
    updatePlaylistState(p, mediaItems);
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

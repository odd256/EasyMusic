/*
 * @Creator: Odd
 * @Date: 2022-02-05 09:43:28
 * @LastEditTime: 2022-02-26 19:00:04
 * @FilePath: \flutter_music_player\lib\utils\audio_player_manager.dart
 */
import 'package:audio_session/audio_session.dart';
import 'package:flutter_music_player/models/audio_metadata.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:just_audio/just_audio.dart';

//单例模式
class AudioPlayerManager {
  AudioPlayer? player;

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  List<Song> playlist = [];

  factory AudioPlayerManager() => _instance;

  //第一次初始化
  AudioPlayerManager._internal() {
    player ??= _init();
  }

  static AudioPlayerManager? getInstance() {
    return _instance;
  }

  _init() {
    _setPlayMode();
    //创建实例对象，并监听后台error
    AudioPlayer player = AudioPlayer();
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    return player;
  }

  _setPlayMode() async {
    //设置播放模式为播放音乐
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  /// i表示在playlist中的下标，如果不输入则直接播放
  play({int? index}) async {
    if (index == null) return player?.play();

    AudioMetadata metadata = AudioMetadata(song: playlist[index]);
    try {
      await player?.setAudioSource(AudioSource.uri(
          Uri.parse(
              "https://music.163.com/song/media/outer/url?id=${playlist[index].id}.mp3"),
          tag: metadata));
      await player?.play();
    } catch (e) {
      MsgUtil.warn("播放失败，换一首吧");
      await player?.stop();
    }
  }

  pause() {
    return player?.pause();
  }

  seek(final Duration? position) {
    player?.seek(position);
  }
}

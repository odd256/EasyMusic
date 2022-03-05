/*
 * @Creator: Odd
 * @Date: 2022-02-05 09:43:28
 * @LastEditTime: 2022-03-05 14:43:20
 * @FilePath: \flutter_music_player\lib\utils\audio_player_manager.dart
 */
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:just_audio/just_audio.dart';

//单例模式
class AudioPlayerManager {
  AudioPlayer? player;

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();

  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

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
    //添加audioSource
    player.setAudioSource(playlist, preload: true);
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
    if (index == null) {
      await player?.play();
      return;
    }

    // AudioMetadata metadata = AudioMetadata(song: playlist[index]);
    try {
      // await player?.setAudioSource(AudioSource.uri(
      //     Uri.parse(
      //         "https://music.163.com/song/media/outer/url?id=${playlist[index].id}.mp3"),
      //     tag: metadata));
      await player?.seek(Duration.zero, index: index);
      await player?.play();
    } catch (e) {
      MsgUtil.warn(msg: "播放失败，换一首吧");
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

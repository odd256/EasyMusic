/*
 * @Creator: Odd
 * @Date: 2022-04-12 14:09:13
 * @LastEditTime: 2022-04-22 00:39:15
 * @FilePath: \flutter_easymusic\lib\controllers\audio_controller.dart
 */

import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_easymusic/api/song_api.dart';
import 'package:flutter_easymusic/models/creator.dart';
import 'package:flutter_easymusic/models/lyric.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:get/get.dart';

/// 音乐播放逻辑的Controller
/// [queue]是用来管理notification的
/// [_plalist]是用来管理Just_Audio的
/// 每次状态更新 两者都要同时调用
class AudioController extends GetxController {
  String currentSongTitle = '';
  Playlist currentPlaylist =
      Playlist(0, '', '', 0, Creator(userId: 0, nickname: '', avatarUrl: ''));

  var currentMediaItems = List<MediaItem>.empty();

  late MediaItem currentMediaItem;

  var lyrics = List<Lyric>.empty();

  ProgressBarState progress = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
  RepeatState repeatButton = RepeatButton._initalState;
  bool isFirstSong = true;
  ButtonState playButton = ButtonState.paused;
  bool isLastSong = true;
  bool isShuffleModeEnabled = false;

  final _audioHandler = Get.find<AudioHandler>();

  @override
  Future<void> onInit() async {
    // await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();

    super.onInit();
  }

  // Future<void> _loadPlaylist() async {
  //   final songRepository = Get.find<PlaylistRepository>();
  //   final playlist = await songRepository.fetchInitialPlaylist();
  //   final mediaItems = playlist
  //       .map((song) => MediaItem(
  //             id: song['id'] ?? '',
  //             album: song['album'] ?? '',
  //             title: song['title'] ?? '',
  //             extras: {'url': song['url']},
  //           ))
  //       .toList();
  //   _audioHandler.addQueueItems(mediaItems);
  // }

  // updatePlaylistAndSongs(Playlist playlist, List<MediaItem> mediaItems){
  //   currentPlaylist = playlist;
  //   currentMediaItems = mediaItems;
  //   update();
  // }

  updatePlaylist(Playlist playlist) {
    currentPlaylist = playlist;
    update();
  }

  ///监听播放列表queue的变化
  ///如果queue改变，则更新playlist
  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        currentPlaylist = Playlist(
            0, '', '', 0, Creator(userId: 0, nickname: '', avatarUrl: ''));
        currentSongTitle = '';
        currentMediaItems = List<MediaItem>.empty();
      } else {
        // final newList = playlist.map<String>((item) => item.title).toList();
        currentMediaItems = playlist;
      }
      _updateSkipButtons();
      update();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButton = ButtonState.loading;
      } else if (!isPlaying) {
        playButton = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButton = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      update();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progress;
      progress = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      update();
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progress;
      progress = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
      update();
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progress;
      progress = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
      update();
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) async {
      currentSongTitle = mediaItem?.title ?? '';
      currentMediaItem = mediaItem ??
          const MediaItem(id: '', album: '', title: '', extras: {'url': ''});
      if (mediaItem != null) {
        //更新歌词
        var data = await SongApi.getLyricBySongId(mediaItem.id);
        lyrics = Lyric.formatLyrics(data['lrc']['lyric']);
        log(lyrics.length.toString());
      }

      _updateSkipButtons();
      update();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSong = true;
      isLastSong = true;
    } else {
      isFirstSong = playlist.first == mediaItem;
      isLastSong = playlist.last == mediaItem;
    }
    update();
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButton = RepeatButton.nextState(repeatButton);
    switch (repeatButton) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
    update();
  }

  void shuffle() {
    final enable = !isShuffleModeEnabled;
    isShuffleModeEnabled = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
    update();
  }

  // Future<void> add() async {
  //   // final songRepository = Get.find<PlaylistRepository>();
  //   // final song = await songRepository.fetchAnotherSong();
  //   // final mediaItem = MediaItem(
  //   //   id: song['id'] ?? '',
  //   //   album: song['album'] ?? '',
  //   //   title: song['title'] ?? '',
  //   //   extras: {'url': song['url']},
  //   // );
  //   _audioHandler.addQueueItem(mediaItem);
  //   update();
  // }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
    update();
  }

  @override
  void dispose() {
    _audioHandler.customAction('dispose');
    super.dispose();
  }

  void stop() {
    _audioHandler.stop();
  }
}

enum ButtonState {
  paused,
  playing,
  loading,
}

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

class RepeatButton {
  static const RepeatState _initalState = RepeatState.off;

  static RepeatState nextState(currentState) {
    final next = (currentState.index + 1) % RepeatState.values.length;
    return RepeatState.values[next];
  }
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

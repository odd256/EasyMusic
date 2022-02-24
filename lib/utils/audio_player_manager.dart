/*
 * @Creator: Odd
 * @Date: 2022-02-05 09:43:28
 * @LastEditTime: 2022-02-16 17:49:02
 * @FilePath: \undefinede:\Projects\flutter_music_player\lib\utils\audio_player_manager.dart
 */
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final playList = ConcatenatingAudioSource(children: []);

  static AudioPlayerManager? _instance;

  AudioPlayerManager._internal();

  AudioPlayer get audioPlayer => _audioPlayer;

  static AudioPlayerManager? getInstance() {
    if(_instance == null){
      _instance = AudioPlayerManager._internal();
      _instance?._init();
    }
    return _instance;
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    _audioPlayer.setAudioSource(playList);
  }
}

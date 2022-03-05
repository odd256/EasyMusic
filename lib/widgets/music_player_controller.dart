/*
 * @Creator: Odd
 * @Date: 2022-02-26 03:46:55
 * @LastEditTime: 2022-03-05 14:49:52
 * @FilePath: \flutter_music_player\lib\widgets\music_player_controller.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_music_player/widgets/player_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../utils/audio_player_manager.dart';

class MusicPlayerController extends StatefulWidget {
  const MusicPlayerController({Key? key}) : super(key: key);

  @override
  _MusicPlayerControllerState createState() => _MusicPlayerControllerState();
}

class _MusicPlayerControllerState extends State<MusicPlayerController> {

late AudioPlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    _playerManager = AudioPlayerManager.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        iconTheme: const IconThemeData(color: Colors.white, size: 57),
      ),
      child: SizedBox(
        height: 140,
        child: Column(
          children: [
            Consumer2<PlayerState, SequenceState?>(
              builder: (
                BuildContext context,
                PlayerState playerState,
                SequenceState? sequenceState,
                Widget? child,
              ) {
                final sequence = sequenceState?.sequence;
                final processingState = playerState.processingState;
                final playing = playerState.playing;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlayerWidget(
                        onPressed: () {
                          if (_playerManager.player!.hasPrevious) {
                            _playerManager.player!.seekToPrevious();
                            _playerManager.play();
                          }
                        },
                        icon: const Icon(Icons.skip_previous_rounded)),
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering)
                      const CircularProgressIndicator()
                    else if (playing != true)
                      PlayerWidget(
                          onPressed: sequence?.isEmpty ?? true
                              ? null
                              : _playerManager.play,
                          icon: const Icon(Icons.play_arrow_rounded))
                    else if (processingState != ProcessingState.completed)
                      PlayerWidget(
                          onPressed: _playerManager.pause,
                          icon: const Icon(Icons.pause_rounded))
                    else
                      PlayerWidget(
                          onPressed: _playerManager.seek(Duration.zero),
                          icon: const Icon(Icons.replay_rounded)),
                    PlayerWidget(
                        onPressed: () {
                          if (_playerManager.player!.hasNext) {
                            _playerManager.player!.seekToNext();
                            _playerManager.play();
                          }
                        },
                        icon: const Icon(Icons.skip_next_rounded)),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.repeat_rounded,
                    size: 30,
                  ),
                ),
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.alarm_rounded,
                    size: 30,
                  ),
                ),
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_rounded,
                    size: 30,
                  ),
                ),
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/pages/music.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class BottomPlayerBar extends StatefulWidget {
  const BottomPlayerBar({Key? key}) : super(key: key);

  @override
  _BottomPlayerBarState createState() => _BottomPlayerBarState();
}

class _BottomPlayerBarState extends State<BottomPlayerBar> {
  late AudioPlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    _playerManager = AudioPlayerManager.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    onPressMusicBar() {
      // TODO: 进入音乐播放页面
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MusicPage()));
    }

    return Consumer2<PlayerState, SequenceState?>(
      builder: (
        BuildContext context,
        PlayerState playerState,
        SequenceState? sequenceState,
        Widget? child,
      ) {
        final sequence = sequenceState?.sequence;
        final metadata = sequenceState?.currentSource?.tag;
        final processingState = playerState.processingState;
        final playing = playerState.playing;

        return Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            SizedBox(
                height: 70,
                width: 70,
                child: sequence?.isEmpty ?? true
                    ? const Icon(
                        Icons.album_rounded,
                        size: 50,
                      )
                    : CachedNetworkImage(imageUrl: metadata.album.picUrl)),
            Positioned(
              left: 90,
              child: SizedBox(
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sequence?.isEmpty ?? true ? '' : metadata.name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        sequence?.isEmpty ?? true
                            ? ''
                            : metadata.showArtist(),
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
            ),
            Material(
              type: MaterialType.transparency,
              child: SizedBox(
                  height: 70,
                  child: InkWell(
                    onTap: sequence?.isEmpty ?? true ? null : onPressMusicBar,
                  )),
            ),
            Positioned(
              right: 10,
              child: Row(
                children: [
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering)
                    const CircularProgressIndicator()
                  else if (playing != true)
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      onPressed: sequence?.isEmpty ?? true
                          ? null
                          : _playerManager.play,
                    )
                  else if (processingState != ProcessingState.completed)
                    IconButton(
                      icon: const Icon(Icons.pause_rounded),
                      onPressed: _playerManager.pause,
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.replay_rounded),
                      onPressed: _playerManager.seek(Duration.zero),
                    ),
                  IconButton(
                      onPressed: () {
                        // TODO: 在这里显示播放列表
                      },
                      icon: const Icon(Icons.view_list_rounded)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

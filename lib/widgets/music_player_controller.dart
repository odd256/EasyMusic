/*
 * @Creator: Odd
 * @Date: 2022-02-26 03:46:55
 * @LastEditTime: 2022-03-01 01:41:59
 * @FilePath: \flutter_music_player\lib\widgets\music_player_controller.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_music_player/widgets/player_widget.dart';

class MusicPlayerController extends StatefulWidget {
  const MusicPlayerController({Key? key}) : super(key: key);

  @override
  _MusicPlayerControllerState createState() => _MusicPlayerControllerState();
}

class _MusicPlayerControllerState extends State<MusicPlayerController> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerWidget(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous_rounded)),
                PlayerWidget(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded)),
                PlayerWidget(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next_rounded)),
              ],
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

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
        height: 120,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.repeat,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                PlayerWidget(
                    onPressed: () {}, icon: const Icon(Icons.skip_previous)),
                PlayerWidget(
                    onPressed: () {}, icon: const Icon(Icons.play_arrow)),
                PlayerWidget(
                    onPressed: () {}, icon: const Icon(Icons.skip_next)),
                const SizedBox(
                  width: 20,
                ),
                PlayerWidget(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.view_list_outlined,
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

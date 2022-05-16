/*
 * @Creator: Odd
 * @Date: 2022-04-21 02:24:08
 * @LastEditTime: 2022-05-17 00:31:48
 * @FilePath: \flutter_easymusic\lib\pages\current_song_page.dart
 */
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/global_widgets/bottom_player_bar.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CurrentSongPage extends StatelessWidget {
  const CurrentSongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = Get.find<AudioHandler>();

    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          onPressed: () => {},
          icon: const Icon(Icons.expand_more_rounded),
          label: const Text('歌词')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GetBuilder<AudioController>(
          init: Get.find<AudioController>(),
          builder: (controller) {
            final playbtn = controller.playButton == ButtonState.playing
                ? Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => audioHandler.pause(),
                      child: const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.pause_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => audioHandler.play(),
                      child: const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );

            return SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon:
                                const Icon(Icons.keyboard_arrow_down_rounded)),
                        const Text(
                          '当前播放',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert_outlined)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                          audioHandler.mediaItem.value?.artUri.toString() ??
                              defaultImgUrl,
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7 + 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share_rounded)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7-100,
                            child: Column(
                              children: [
                                Text(
                                  audioHandler.mediaItem.value?.title ?? '',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                                Text(audioHandler.mediaItem.value?.artist ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16))
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bedtime_rounded)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconTheme(
                      data: const IconThemeData(size: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.shuffle_rounded)),
                          IconButton(
                              onPressed: () => audioHandler.skipToPrevious(),
                              icon: const Icon(Icons.skip_previous_outlined)),
                          playbtn,
                          IconButton(
                              onPressed: () => audioHandler.skipToNext(),
                              icon: const Icon(Icons.skip_next_outlined)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.repeat_rounded)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ));
          }),
      // borderRadius: const BorderRadius.vertical(
      //   top: Radius.circular(14),
      // ),
    );
  }
}

class LyricListView extends StatelessWidget {
  const LyricListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("画歌词"),
      ),
    );
  }
}

class LyricPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

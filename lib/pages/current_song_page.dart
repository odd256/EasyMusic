/*
 * @Creator: Odd
 * @Date: 2022-04-21 02:24:08
 * @LastEditTime: 2022-04-21 23:18:02
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
        body: SlidingUpPanel(
      renderPanelSheet: false,
      collapsed: _buildFloatingCollapsed(),
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      minHeight: 50,
      body: GetBuilder<AudioController>(
        init: Get.find<AudioController>(),
        builder: (controller) => SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded)),
                  const Text(
                    '当前播放',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.share_rounded)),
                  Column(
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
                              fontWeight: FontWeight.w500, fontSize: 16))
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bedtime_rounded)),
                ],
              ),
              const SizedBox(height: 20),
              IconTheme(
                data: const IconThemeData(size: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shuffle_rounded)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous_rounded)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next_rounded)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.repeat_rounded)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      panel: _buildFloatingPanel(),
      // borderRadius: const BorderRadius.vertical(
      //   top: Radius.circular(14),
      // ),
    ));
  }

  Container _buildFloatingPanel() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      margin: const EdgeInsets.all(24.0),
      child: const LyricListView(),
    );
  }

  Container _buildFloatingCollapsed() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      child: const Center(child: Icon(Icons.expand_less_rounded)),
    );
  }
}

class LyricListView extends StatelessWidget {
  const LyricListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("This is the SlidingUpPanel when open"),
      ),
    );
  }
}

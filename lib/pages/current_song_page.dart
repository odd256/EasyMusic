/*
 * @Creator: Odd
 * @Date: 2022-04-21 02:24:08
 * @LastEditTime: 2022-05-19 11:30:07
 * @FilePath: \flutter_easymusic\lib\pages\current_song_page.dart
 */
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/global_widgets/bottom_player_bar.dart';
import 'package:get/get.dart';

import '../models/lyric.dart';

class CurrentSongPage extends StatelessWidget {
  const CurrentSongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioHandler = Get.find<AudioHandler>();

    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          onPressed: () => {
                Get.to(
                  () => const LyricView(),
                )
              },
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
                    _buildFunctionalBtn(context, audioHandler),
                    const SizedBox(height: 20),
                    _buildControllBtn(audioHandler, playbtn),
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

  _buildControllBtn(AudioHandler audioHandler, Material playbtn) {
    return IconTheme(
      data: const IconThemeData(size: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => {}, icon: const Icon(Icons.shuffle_rounded)),
          IconButton(
              onPressed: () => audioHandler.skipToPrevious(),
              icon: const Icon(Icons.skip_previous_outlined)),
          playbtn,
          IconButton(
              onPressed: () => audioHandler.skipToNext(),
              icon: const Icon(Icons.skip_next_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.repeat_rounded)),
        ],
      ),
    );
  }

  _buildFunctionalBtn(BuildContext context, AudioHandler audioHandler) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7 + 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7 - 100,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                          fontSize: 16))
                ],
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.bedtime_rounded)),
        ],
      ),
    );
  }
}

class LyricView extends StatelessWidget {
  const LyricView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
      init: AudioController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('歌词'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: LyricPainter(_.lyrics),
            ),
          ),
        );
      },
    );
  }
}

class LyricPainter extends CustomPainter {
  List<Lyric> lyrics = []; // 歌词文本

  List<TextPainter> lyricPaints = []; // 画笔

  LyricPainter(this.lyrics) {
    lyricPaints.addAll(lyrics
        .map<TextPainter>((l) => TextPainter(
            text: TextSpan(
                text: l.lyric,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center))
        .toList());
  }

  @override
  void paint(Canvas canvas, Size size) {
    log(size.height.toString());
    double lineHight = 0;
    for (int i = 0; i < lyricPaints.length; i++) {
      lyricPaints[i].layout(maxWidth: size.width);
      lyricPaints[i].paint(
          canvas, Offset((size.width - lyricPaints[i].width) / 2, lineHight));

      //最后更新一下行高
      lineHight += lyricPaints[i].height + 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

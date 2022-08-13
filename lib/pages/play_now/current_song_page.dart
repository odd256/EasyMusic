/*
 * @Creator: Odd
 * @Date: 2022-04-21 02:24:08
 * @LastEditTime: 2022-08-14 03:09:50
 * @FilePath: \EasyMusic\lib\pages\play_now\current_song_page.dart
 */
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:get/get.dart';

import '../../models/lyric.dart';

class CurrentSongPage extends StatefulWidget {
  const CurrentSongPage({Key? key}) : super(key: key);

  @override
  State<CurrentSongPage> createState() => _CurrentSongPageState();
}

class _CurrentSongPageState extends State<CurrentSongPage> {
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                curIndex == 0 ? curIndex = 1 : curIndex = 0;
              });
            },
            icon: Icon(curIndex == 0
                ? Icons.expand_more_rounded
                : Icons.expand_less_rounded),
            label: Text(curIndex == 0 ? '歌词' : '返回')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: IndexedStack(
          index: curIndex,
          children: const [CurrentSongView(), LyricView()],
        ));
  }
}

class CurrentSongView extends StatelessWidget {
  const CurrentSongView({Key? key}) : super(key: key);

  _buildControllBtn(AudioHandler audioHandler, AudioController ac) {
    final playbtn = ac.playButton == ButtonState.playing
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
                crossAxisAlignment: CrossAxisAlignment.center,
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

  @override
  Widget build(BuildContext context) {
    final audioHandler = Get.find<AudioHandler>();
    final audioController = Get.find<AudioController>();

    return GetBuilder<AudioController>(
        init: Get.find<AudioController>(),
        builder: (controller) {
          return SafeArea(
              bottom: false,
              child: Stack(children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: double.infinity,
                  fadeInDuration: const Duration(),
                  fadeOutDuration: const Duration(),
                  width: double.infinity,
                  imageUrl:
                      audioHandler.mediaItem.value?.artUri.toString() ?? '',
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.error_outline_rounded),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                  child: Opacity(
                      opacity: 0.3,
                      child: Container(
                        color: Colors.white,
                      )),
                ),
                Column(
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
                    _buildSongCover(context, audioHandler, audioController),
                    const SizedBox(height: 20),
                    _buildFunctionalBtn(context, audioHandler),
                    const SizedBox(height: 20),
                    _buildControllBtn(audioHandler, audioController),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ]));
        });
  }

  Container _buildSongCover(BuildContext context, AudioHandler audioHandler,
      AudioController audioController) {
    final coverHeight = MediaQuery.of(context).size.height * 0.45;
    final coverWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      height: coverHeight,
      width: coverWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(153, 122, 122, 122),
              offset: Offset(1.5, 1.5),
              blurRadius: 1.0,
              spreadRadius: 1.0),
          // BoxShadow(color: Colors.grey, offset: Offset(4.0, 4.0)),
          // BoxShadow(color: Colors.white, offset: Offset(0.0, 0.0)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: audioHandler.mediaItem.value?.artUri.toString() ?? '',
          placeholder: (_, __) => Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          errorWidget: (_, __, ___) => const Icon(Icons.error_outline_rounded),
        ),
      ),
    );
  }
}

class LyricView extends StatelessWidget {
  const LyricView({Key? key}) : super(key: key);

  //找到当前行的Index，为做效果做准备
  int findCurLineIndex(Duration curTime, lyrics) {
    int idx = 0;
    double offset = 0.5; //歌词的偏移值
    for (int i = 0; i < lyrics.length; i++) {
      if (curTime.inMilliseconds + offset >=
              lyrics[i].startTime.inMilliseconds &&
          curTime.inMilliseconds + offset <= lyrics[i].endTime.inMilliseconds) {
        idx = i;
      }
    }
    return idx;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
      init: AudioController(),
      initState: (_) {},
      builder: (_) {
        return Column(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: LyricPainter(
                  lyrics: _.lyrics,
                  curLineIndex: findCurLineIndex(_.progress.current, _.lyrics)),
            ),
          ],
        );
      },
    );
  }
}

class LyricPainter extends CustomPainter {
  List<Lyric> lyrics = []; // 歌词文本

  int curLineIndex = -1; // 当前行

  List<TextPainter> lyricPaints = []; // 画笔

  LyricPainter({required this.curLineIndex, required this.lyrics}) {
    lyricPaints.addAll(lyrics
        .map<TextPainter>((l) => TextPainter(
            text: TextSpan(
                text: l.lyric,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center))
        .toList());
  }

  //计算当前Y轴的偏移量
  // double calculateOffsetY() {
  //   if (curLineIndex >= 0) {
  //     double offset = 0;
  //     for (int i = 0; i < curLineIndex; i++) {
  //       // offset += lyricPaints[i].height + 10;
  //     }
  //     return offset;
  //   }

  //   return 0;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    double middle = size.height * (1 / 4);
    double curLineHight = 0;
    for (int i = 0; i < lyricPaints.length; i++) {
      if (curLineIndex == i) {
        //渲染当前行
        lyricPaints[i].text = TextSpan(
            text: lyrics[i].lyric,
            style: const TextStyle(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold));
        lyricPaints[i].layout(maxWidth: size.width);
        lyricPaints[i].paint(
            canvas,
            Offset((size.width - lyricPaints[i].width) / 2,
                curLineHight - lyrics[curLineIndex].offset + middle));
      } else {
        //渲染其他行
        lyricPaints[i].layout(maxWidth: size.width);
        lyricPaints[i].paint(
            canvas,
            Offset((size.width - lyricPaints[i].width) / 2,
                curLineHight - lyrics[curLineIndex].offset + middle));
      }
      //最后更新一下行高和偏移量
      lyrics[i].offset = curLineHight;
      curLineHight += lyricPaints[i].height + 10;
    }
  }

  @override
  bool shouldRepaint(covariant LyricPainter oldDelegate) {
    return oldDelegate.curLineIndex != curLineIndex;
  }
}

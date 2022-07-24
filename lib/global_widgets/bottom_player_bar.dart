/*
 * @Creator: Odd
 * @Date: 2022-04-15 15:00:19
 * @LastEditTime: 2022-07-25 02:44:48
 * @FilePath: \flutter_easymusic\lib\global_widgets\bottom_player_bar.dart
 */

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:get/get.dart';

const String defaultImgUrl =
    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F13633347286%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1652722376&t=dfc48d0e5d3cdf81ad0075013f89d710';

class BottomPlayerBar extends StatelessWidget {
  const BottomPlayerBar({Key? key}) : super(key: key);

  _buildControlButton() {
    final ac = Get.find<AudioController>();
    var playbtn = ac.playButton == ButtonState.playing
        ? IconButton(
            onPressed: () {
              ac.pause();
            },
            icon: const Icon(
              Icons.pause_outlined,
              color: Colors.white,
            ),
          )
        : IconButton(
            onPressed: () {
              ac.play();
            },
            icon: const Icon(
              Icons.play_arrow_outlined,
              color: Colors.white,
            ),
          );

    var nextbtn = IconButton(
      onPressed: () {
        ac.next();
      },
      icon: const Icon(
        Icons.skip_next_outlined,
        color: Colors.white,
      ),
    );
    var prebtn = IconButton(
      onPressed: () {
        ac.previous();
      },
      icon: const Icon(
        Icons.skip_previous_outlined,
        color: Colors.white,
      ),
    );
    return IconTheme(
      data: const IconThemeData(color: Colors.white, size: 30),
      child: Row(
        children: [
          prebtn,
          playbtn,
          nextbtn,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ah = Get.find<AudioHandler>();

    return GetBuilder<AudioController>(
      init: AudioController(),
      builder: (_) {
        return ah.queue.value.isEmpty?Container():InkWell(
          onTap: () => Get.toNamed(AppRoutes.currentSong),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 70,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ah.mediaItem.value?.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Text(
                            ah.mediaItem.value?.artist ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  _buildControlButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

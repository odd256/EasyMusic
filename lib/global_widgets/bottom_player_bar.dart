/*
 * @Creator: Odd
 * @Date: 2022-04-15 15:00:19
 * @LastEditTime: 2022-04-21 21:35:24
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

  @override
  Widget build(BuildContext context) {
    final ah = Get.find<AudioHandler>();

    return GetBuilder<AudioController>(
      init: AudioController(),
      builder: (_) {
        return InkWell(
          onTap: () => Get.toNamed(AppRoutes.currentSong),
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                Image.network(
                    ah.mediaItem.value?.artUri.toString() ?? defaultImgUrl),
                Column(
                  children: [
                    Text(ah.mediaItem.value?.title ?? '',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

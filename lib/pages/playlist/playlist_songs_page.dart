// ignore_for_file: prefer_const_constructors

/*
 * @Creator: Odd
 * @Date: 2022-04-13 21:57:27
 * @LastEditTime: 2022-07-25 02:42:48
 * @FilePath: \flutter_easymusic\lib\pages\playlist_songs_page.dart
 */
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/audio_controller.dart';
import 'package:flutter_easymusic/controllers/playlist_songs_controller.dart';
import 'package:flutter_easymusic/global_widgets/bottom_player_bar.dart';
import 'package:flutter_easymusic/global_widgets/custom_shimmer.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:get/get.dart';

class PlaylistSongsPage extends StatelessWidget {
  PlaylistSongsPage({Key? key}) : super(key: key);

  final title = '歌单详情';
  final id = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PlaylistHeader(),
              ),
              SliverToBoxAdapter(
                child: ControllButton(),
              ),
              SongSliverListView(),
            ],
          ),
        ),
        floatingActionButton: const BottomPlayerBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class PlaylistHeader extends StatelessWidget {
  const PlaylistHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistState = Get.find<PlaylistState>();
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: playlistState.currentPlaylist.value.coverImgUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (_, __) => SizedBox(height: 150, width: 150),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlistState.currentPlaylist.value.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          width: 24,
                          height: 24,
                          imageUrl: playlistState
                              .currentPlaylist.value.creator.avatarUrl,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(playlistState.currentPlaylist.value.creator.nickname,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class ControllButton extends StatelessWidget {
  const ControllButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 12)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff24abe3)),
                  textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 16))))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ElevatedButton.icon(
                  label: const Text('随机播放'),
                  onPressed: () => {},
                  icon: const Icon(Icons.shuffle_rounded),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton.icon(
                  label: const Text(
                    '顺序播放',
                  ),
                  onPressed: () => {},
                  icon: const Icon(Icons.queue_music_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongSliverListView extends StatelessWidget {
  const SongSliverListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlaylistSongsController psController =
        Get.find<PlaylistSongsController>();
    final PlaylistState playlistState = Get.find<PlaylistState>();
final ah = Get.find<AudioHandler>();

    int calculateCount() {
      bool isQueued = ah.queue.value.isNotEmpty;
      int s = 0;
      if(psController.onLoad.value) {
        return 7;
      }
      else if (isQueued) {
        s = 2;
      }
      return playlistState.currentMediaItems.length + s;
    }
    return Obx(() => SliverPrototypeExtentList(
          delegate: SliverChildBuilderDelegate(
              (c, i) => psController.onLoad.value
                  ? _buildShimmerListTile(context, i)
                  : _buildSongListTile(psController, playlistState, i),
              // childCount: psController.onLoad.value
              //     ? 7
              //     : playlistState.currentMediaItems.length + 2
              childCount: calculateCount()
                  ),
          prototypeItem: const ListTile(
            title: Text(''),
            subtitle: Text(''),
          ),
        ));
  }

  _buildShimmerListTile(context, i) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer.rectangular(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomShimmer.rectangular(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildSongListTile(PlaylistSongsController psController,
      PlaylistState playlistState, int i) {
    if (i >= playlistState.currentMediaItems.length) return const ListTile();
    final mediaItemId = playlistState.currentMediaItems[i].id;
    return GetBuilder<AudioController>(
      init: AudioController(),
      initState: (_) {},
      builder: (_) {
        final curMediaItemId = _.currentMediaItem.id;
        return ListTile(
          onTap: () => psController.onSonglistItemClick(
              playlistState.currentPlaylist.value, i),
          title: Text(
            playlistState.currentMediaItems[i].title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: curMediaItemId.compareTo(mediaItemId) == 0
                    ? Colors.blue
                    : Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            playlistState.currentMediaItems[i].artist!,
            style: TextStyle(
                fontSize: 14,
                color: curMediaItemId.compareTo(mediaItemId) == 0
                    ? Colors.blue
                    : Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SizedBox(
              width: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (curMediaItemId.compareTo(mediaItemId) == 0)
                    Icon(
                      Icons.equalizer_rounded,
                      color: Colors.blue,
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.favorite_border_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.more_vert_rounded),
                ],
              )),
        );
      },
    );
  }
}

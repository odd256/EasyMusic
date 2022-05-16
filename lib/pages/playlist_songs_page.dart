// ignore_for_file: prefer_const_constructors

/*
 * @Creator: Odd
 * @Date: 2022-04-13 21:57:27
 * @LastEditTime: 2022-05-16 22:27:40
 * @FilePath: \flutter_easymusic\lib\pages\playlist_songs_page.dart
 */
import 'package:flutter/material.dart';
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
        // bottomNavigationBar: const BottomPlayerBar(),
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
              child: Image.network(
                  playlistState.currentPlaylist.value.coverImgUrl,
                  width: 150,
                  height: 150),
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
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(
                          playlistState.currentPlaylist.value.creator.avatarUrl,
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
    return Obx(() => SliverPrototypeExtentList(
          delegate: SliverChildBuilderDelegate(
              (c, i) => psController.onLoad.value
                  ? _buildShimmerListTile(context, i)
                  : _buildSongListTile(psController, playlistState, i),
              childCount: psController.onLoad.value
                  ? 7
                  : playlistState.currentMediaItems.length + 2),
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
          SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: Text(
                '${i + 1}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 15),
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

  ListTile _buildSongListTile(psController, playlistState, int i) {
    if (i >= playlistState.currentMediaItems.length) return const ListTile();

    return ListTile(
      onTap: () => psController.onSonglistItemClick(
          playlistState.currentPlaylist.value, i),
      title: Text(
        playlistState.currentMediaItems[i].title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        playlistState.currentMediaItems[i].artist!,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/*
 * @Creator: Odd
 * @Date: 2022-04-13 21:57:27
 * @LastEditTime: 2022-05-16 19:22:53
 * @FilePath: \flutter_easymusic\lib\pages\playlist_songs_page.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // final songs = Get.find<PlaylistSongsController>().songs;
    // final playlist = Get.find<AudioController>().currentPlaylist;
    // final audioController = Get.find<AudioController>();
    final psController = Get.find<PlaylistSongsController>();
    final playlistState = Get.find<PlaylistState>();
    return Scaffold(
      body: Obx(() => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: PlaylistSliverHeaderDelegate(
                    collapsedHeight: 40,
                    expandedHeight: 300,
                    paddingTop: MediaQuery.of(context).padding.top,
                    title: '共${playlistState.currentMediaItems.length}首',
                  )),
              SongSliverList(
                  psController: psController, playlistState: playlistState)
            ],
          )),
      floatingActionButton: const BottomPlayerBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: const BottomPlayerBar(),
    );
  }
}

class SongSliverList extends StatelessWidget {
  const SongSliverList({
    Key? key,
    required this.psController,
    required this.playlistState,
  }) : super(key: key);

  final PlaylistSongsController psController;
  final PlaylistState playlistState;

  @override
  Widget build(BuildContext context) {
    return SliverPrototypeExtentList(
      delegate: SliverChildBuilderDelegate(
          (c, i) => psController.onLoad.value
              ? _buildShimmerListTile(context, i)
              : _buildSongListTile(i),
          childCount: psController.onLoad.value
              ? 7
              : playlistState.currentMediaItems.length),
      prototypeItem: const ListTile(
        title: Text(''),
        subtitle: Text(''),
        leading: Icon(Icons.print_rounded),
      ),
    );
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

  ListTile _buildSongListTile(int i) {
    return ListTile(
      onTap: () => psController.onSonglistItemClick(
          playlistState.currentPlaylist.value, i),
      title: Text(
        playlistState.currentMediaItems[i].title,
        overflow: TextOverflow.ellipsis,
      ),
      leading: SizedBox(
        child: Center(
            child: Text(
          '${i + 1}',
          style: const TextStyle(fontSize: 20),
        )),
        height: 50,
        width: 50,
      ),
      subtitle: Text(
        playlistState.currentMediaItems[i].artist!,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class PlaylistSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String title;
  String statusBarMode = 'dark';
  PlaylistSliverHeaderDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.paddingTop,
    required this.title,
  });

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && statusBarMode == 'dark') {
      statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (shrinkOffset <= 50 && statusBarMode == 'light') {
      statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha =
        (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha =
          (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  _buildPlaylistInfo() {
    final playlistState = Get.find<PlaylistState>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.only(top: paddingTop),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
            ),
            height: 140,
            width: 140,
            child: Image.network(
              playlistState.currentPlaylist.value.coverImgUrl,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    updateStatusBarBrightness(shrinkOffset);
    final playlistState = Get.find<PlaylistState>();
    return SizedBox(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          // Image.network(
          //     playlistState.currentPlaylist.value.coverImgUrl,
          //     fit: BoxFit.cover),
          _buildPlaylistInfo(),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight + paddingTop;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class PlaylistDetail extends StatelessWidget {
  const PlaylistDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistState = Get.find<PlaylistState>();
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10.0)
                    ],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: NetworkImage(
                            playlistState.currentPlaylist.value.coverImgUrl))),
              ),
              Container(
                width: 200,
                height: 170,
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlistState.currentPlaylist.value.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 15,
                              foregroundImage: NetworkImage(playlistState
                                  .currentPlaylist.value.creator.avatarUrl)),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                playlistState
                                    .currentPlaylist.value.creator.nickname,
                                style: const TextStyle(fontSize: 17),
                              )),
                        ],
                      ),
                      Text(
                          '共收录${playlistState.currentPlaylist.value.trackCount}首歌',
                          style: const TextStyle(fontSize: 14)),
                    ]),
              )
            ],
          ),
        ));
  }
}

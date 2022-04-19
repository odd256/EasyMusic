/*
 * @Creator: Odd
 * @Date: 2022-04-13 21:57:27
 * @LastEditTime: 2022-04-19 11:10:06
 * @FilePath: \flutter_easymusic\lib\pages\playlist_songs_page.dart
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/playlist_songs_controller.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
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
                SliverAppBar(
                  pinned: true,
                  // 滑动到顶端时会固定住
                  stretch: true,
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  actions: [
                    IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.search),
                        icon: const Icon(Icons.search_rounded)),
                  ],
                  expandedHeight: 320.0,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        playlistState.currentPlaylist.value.coverImgUrl,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      // FadeInImage.memoryNetwork(
                      //   fit: BoxFit.cover,
                      //   height: double.infinity,
                      //   width: double.infinity,
                      //   image: playlistState.currentPlaylist.value.coverImgUrl,
                      //   placeholder: kTransparentImage,
                      // ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      const PlaylistDetail(),
                    ],
                  )),
                ),
                SliverPrototypeExtentList(
                  delegate: SliverChildBuilderDelegate(
                      (c, i) => ListTile(
                            onTap: () {
                              //播放歌曲
                              psController.onSonglistItemClick(
                                  playlistState.currentPlaylist.value, i);
                            },
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
                          ),
                      childCount: playlistState.currentMediaItems.length),
                  prototypeItem: const ListTile(
                    title: Text(''),
                    subtitle: Text(''),
                    leading: Icon(Icons.print_rounded),
                  ),
                )
              ],
            )));
  }
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

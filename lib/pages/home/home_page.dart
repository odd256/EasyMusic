// ignore_for_file: prefer_const_constructors

/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:08:52
 * @LastEditTime: 2022-08-01 01:08:14
 * @FilePath: \EasyMusic\lib\pages\home_page.dart
 */

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easymusic/controllers/playlist_controller.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:flutter_easymusic/global_widgets/bottom_player_bar.dart';
import 'package:flutter_easymusic/global_widgets/custom_shimmer.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:flutter_easymusic/utils/msg_util.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  _buildHomePage(context, scaffoldKey) {
    return CustomScrollView(
      controller: Get.find<PlaylistController>().scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
            pinned: true,
            delegate: UserSliverHeaderDelegate(
              scaffoldKey: scaffoldKey,
              title: '我的歌单',
              collapsedHeight: 62,
              expandedHeight: 380,
              paddingTop: MediaQuery.of(context).padding.top,
            )),
        const PlaylistItemListWidget()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt; //上次点击时间
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 1)) {
          //间隔超过一秒重新计时
          _lastPressedAt = DateTime.now();
          MsgUtil.notice('再按一次退出应用');
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawerEdgeDragWidth: 150,
        drawer: const HomeDrawer(),
        floatingActionButton: const BottomPlayerBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _buildHomePage(context, _scaffoldKey),
        // bottomNavigationBar: const BottomPlayerBar(),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  _buildListTile(String title, IconData icon, {onTapAction}) => ListTile(
        onTap: onTapAction,
        leading: Icon(icon),
        title: Text(title),
      );

  @override
  Widget build(BuildContext context) {
    final usercontroller = Get.find<UserController>();
    return Drawer(
      backgroundColor: const Color(0xFFF5F5F5),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildListTile('关于', Icons.announcement_rounded,
                      onTapAction: () {}),
                  _buildListTile('设置', Icons.settings_rounded,
                      onTapAction: () {}),
                  _buildListTile('账号', Icons.person_add, onTapAction: () {
                    Get.toNamed(AppRoutes.login);
                  }),
                  _buildListTile('登出', Icons.logout_rounded,
                      onTapAction: ()=>usercontroller.logout()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  String statusBarMode = 'dark';
  UserSliverHeaderDelegate({
    required this.scaffoldKey,
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

  _buildUserInfo() {
    final userState = Get.find<UserState>();

    return Obx(() => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  foregroundImage: userState.isLogin.value
                      ? NetworkImage(userState.user.value.avatarUrl)
                      : null,
                  child: userState.isLogin.value
                      ? null
                      : const Text(
                          '登录',
                          style: TextStyle(fontSize: 11),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userState.user.value.uname,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'id: ${userState.user.value.id}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w300),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    updateStatusBarBrightness(shrinkOffset);
    final userState = Get.find<UserState>();
    return SizedBox(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: userState.user.value.backgroundUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            top: maxExtent / 2,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x90000000),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildUserInfo(),
          ),
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
                          Icons.reorder_rounded,
                          color: makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () => Get.toNamed('/search'),
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

class PlaylistItemListWidget extends StatelessWidget {
  const PlaylistItemListWidget({Key? key}) : super(key: key);

  _buildPlaylistListTile(playlistController, i) {
    if (i >= playlistController.playlists.length) {
      return const SizedBox();
    }

    Playlist playlist = playlistController.playlists[i];
    return ListTile(
      onTap: () => {
        //在路由过之前，先将playlist传给playlistState
        // Get.find<PlaylistSongsController>().getMySongsByPlaylist(playlist),
        Get.find<PlaylistState>().currentPlaylist.value = playlist,
        Get.toNamed(AppRoutes.playlistSongs)
      },
      title: Text(
        playlist.name,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CachedNetworkImage(
        imageUrl: playlist.coverImgUrl,
        width: 55,
        height: 55,
        placeholder: (context, url) => SizedBox(height: 55, width: 55),
        errorWidget: (context, url, error) => const AspectRatio(
          aspectRatio: 1 / 1,
          child: SizedBox(
            width: 55,
            height: 55,
            child: Icon(Icons.error),
          ),
        ),
      ),
      subtitle: Text('${playlist.trackCount} 首'),
    );
  }

  _buildShimmerListTile(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          const CustomShimmer.rectangular(
            height: 55,
            width: 55,
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

  @override
  Widget build(BuildContext context) {
    final playlistController = Get.find<PlaylistController>();
    final ah = Get.find<AudioHandler>();

    int calculateCount() {
      bool isQueued = ah.queue.value.isNotEmpty;
      int s = 0;
      if (playlistController.onLoad.value) {
        return 5;
      }
      else if (isQueued) {
        s = 2;
      }
      return playlistController.playlists.length + s;
    }

    return Obx(() => SliverPrototypeExtentList(
          delegate: SliverChildBuilderDelegate(
              (c, i) => playlistController.onLoad.value
                  ? _buildShimmerListTile(context)
                  : _buildPlaylistListTile(playlistController, i),

              // childCount: playlistController.onLoad.value
              //     ? 5
              //     : playlistController.playlists.length + 2
              childCount: calculateCount()),
          prototypeItem: const ListTile(
            title: Text(''),
            subtitle: Text(''),
            leading: Icon(Icons.print_rounded),
          ),
        ));
  }
}

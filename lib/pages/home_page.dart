/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:08:52
 * @LastEditTime: 2022-04-19 11:09:53
 * @FilePath: \flutter_easymusic\lib\pages\home_page.dart
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/playlist_controller.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:flutter_easymusic/utils/keep_alive_wrapper.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  _buildHomePage() {
    return CustomScrollView(
      controller: Get.find<PlaylistController>().scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: const [UserHeaderWidget(), PlaylistItemListWidget()],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime? _lastPressedAt; //上次点击时间
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 1)) {
          //间隔超过一秒重新计时
          _lastPressedAt = DateTime.now();
          Get.snackbar(
            '提示', // title
            '再按一次退出应用', // message
            icon: const Icon(Icons.sentiment_satisfied_rounded),
            shouldIconPulse: true,
            snackPosition: SnackPosition.BOTTOM,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 3),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        drawerEdgeDragWidth: 150,
        drawer: const HomeDrawer(),
        body: _buildHomePage(),
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
                      onTapAction: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({Key? key}) : super(key: key);

  _buildUserTitle(showBlur) {
    final userState = Get.find<UserState>();

    return Obx(() => InkWell(
          onTap: () => userState.isLogin.value
              ? Get.snackbar('提示', '用户已登录')
              : Get.toNamed(AppRoutes.login),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: BackdropFilter(
              filter: showBlur
                  ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                color: Colors.white.withOpacity(0.3),
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
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final userState = Get.find<UserState>();

    return SliverAppBar(
      pinned: true,
      stretch: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {
            Get.toNamed(AppRoutes.search);
          },
        ),
      ],
      expandedHeight: 300,
      flexibleSpace: Obx(() => FlexibleSpaceBar(
            centerTitle: true,
            title: _buildUserTitle(true),
            titlePadding: const EdgeInsets.all(0),
            stretchModes: const [StretchMode.zoomBackground],
            background: userState.isLogin.value
                ? FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: kTransparentImage,
                    image: userState.user.value.backgroundUrl)
                : Container(
                    color: Colors.white,
                  ),
          )),
    );
  }
}

class PlaylistItemListWidget extends StatelessWidget {
  const PlaylistItemListWidget({Key? key}) : super(key: key);

  _buildPlaylistListTile(Playlist playlist) => ListTile(
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
        leading: Image.network(
          playlist.coverImgUrl,
          width: 55,
          height: 55,
          fit: BoxFit.fill,
        ),
        subtitle: Text('${playlist.trackCount} 首'),
      );

  @override
  Widget build(BuildContext context) {
    final playListController = Get.find<PlaylistController>();
    return Obx(() => SliverPrototypeExtentList(
          delegate: SliverChildBuilderDelegate(
              (c, i) => KeepAliveWrapper(
                    keepAlive: true,
                    child:
                        _buildPlaylistListTile(playListController.playlists[i]),
                  ),
              childCount: playListController.playlists.length),
          prototypeItem: const ListTile(
            title: Text(''),
            subtitle: Text(''),
            leading: Icon(Icons.print_rounded),
          ),
        ));
  }
}

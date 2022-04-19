/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:08:52
 * @LastEditTime: 2022-04-19 23:58:47
 * @FilePath: \flutter_easymusic\lib\pages\home_page.dart
 */


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easymusic/controllers/playlist_controller.dart';
import 'package:flutter_easymusic/models/playlist.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

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
              collapsedHeight: 40,
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
        key: _scaffoldKey,
        drawerEdgeDragWidth: 150,
        drawer: const HomeDrawer(),
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

class UserSliverAppBar extends StatelessWidget {
  const UserSliverAppBar({Key? key}) : super(key: key);

  _buildUserTitle() {
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
            title: _buildUserTitle(),
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
          Image.network(userState.user.value.backgroundUrl, fit: BoxFit.cover),
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
              (c, i) => _buildPlaylistListTile(playListController.playlists[i]),
              childCount: playListController.playlists.length),
          prototypeItem: const ListTile(
            title: Text(''),
            subtitle: Text(''),
            leading: Icon(Icons.print_rounded),
          ),
        ));
  }
}

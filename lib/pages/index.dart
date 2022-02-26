import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/play_list.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/list.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/keep_alive_wrapper.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_music_player/pages/login.dart';
import 'package:flutter_music_player/pages/search.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:sp_util/sp_util.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List _playList = [];

  bool isFirstLoad = true; // 是否是第一次加载

  bool showBlur = true; // 是否模糊背景

  DateTime? _lastPressedAt; //上次点击时间

  final ScrollController _controller = ScrollController(); // 滚动控制器

  late HttpManager _httpManager; // http管理器

  AudioPlayerManager audioPlayerManager = AudioPlayerManager.getInstance()!;

  //左侧设置栏
  _buildListTile(String title, IconData icon, [onTap]) => ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title),
      );

  //构建左侧设置栏
  _buildListColumn(List<Widget> items) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: items,
          ),
        ),
      );

  //显示歌单
  _buildIndexPage(onTop) => CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            // 滑动到顶端时会固定住
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) {
                      return const SearchPage();
                    }),
                  );
                },
                icon: const Icon(Icons.search_rounded),
              )
            ],
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: onTop,
              titlePadding: const EdgeInsets.all(0),
              stretchModes: const [StretchMode.zoomBackground],
              background: context.watch<User>().isLogin
                  ? SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          imageUrl: context.watch<User>().backgroundUrl,
                          errorWidget: (c, u, e) =>
                              const Icon(Icons.error)),
                    )
                  : Container(
                      color: Colors.white,
                    ),
            ),
          ),
          SliverPrototypeExtentList(
            delegate: SliverChildBuilderDelegate(
                (c, i) => KeepAliveWrapper(
                      keepAlive: true,
                      child: ListTile(
                        onTap: () {
                          //点击进入歌单列表
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => PlayListPage(
                                        title: '歌单详情',
                                        playList: _playList[i],
                                      )));
                        },
                        title: Text(
                          _playList[i].name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: CachedNetworkImage(
                          width: 47,
                          progressIndicatorBuilder: (c, u, d) =>
                              LinearProgressIndicator(value: d.progress),
                          imageUrl: _playList[i].coverImgUrl,
                          errorWidget: (c, u, e) => const Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        subtitle: Text('${_playList[i].trackCount} 首'),
                      ),
                    ),
                childCount: _playList.length),
            prototypeItem: const ListTile(
              title: Text(''),
              subtitle: Text(''),
              leading: Icon(Icons.print),
            ),
          )
        ],
      );

  //获取用户歌单
  _getUserPlayList(id) async {
    var data = await _httpManager.get('/user/playlist?uid=$id');
    setState(() {
      _playList = data['playlist'].map((e) {
        return PlayList.fromJson(e);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _httpManager = HttpManager.getInstance();
    _controller.addListener(() {
      if (_controller.offset > 200) {
        if (showBlur != false) {
          setState(() {
            showBlur = false;
          });
        }
      } else {
        if (showBlur != true) {
          setState(() {
            showBlur = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User u = context.watch<User>();
    print(context);

    ///显示用户的名称
    ///显示用户的头像
    ///显示用户的id
    var onTop = InkWell(
      onTap: () {
        if (u.isLogin) {
          MsgUtil.primary('用户已登录');
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (c) => const LoginPage()));
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: showBlur
              ? ImageFilter.blur(sigmaX: 30, sigmaY: 30)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  foregroundImage: u.isLogin ? NetworkImage(u.avatarUrl) : null,
                  child: u.isLogin
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
                        u.uname,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'id: ${u.id}',
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
    );
    //用户歌单更新
    if (isFirstLoad) {
      _getUserPlayList(u.id);
      isFirstLoad = false;
    }
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 1)) {
          //间隔超过一秒重新计时
          _lastPressedAt = DateTime.now();
          MsgUtil.tip(msg: '再按一次退出应用');
          return false;
        }
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: const Color(0xFFF5F5F5),
          child: ListView(
            children: [
              _buildListColumn([
                _buildListTile('关于', Icons.announcement_rounded),
                _buildListTile('设置', Icons.settings),
                _buildListTile('账号', Icons.person_add_rounded, () {
                  if (!u.isLogin) {
                    Navigator.push(context, MaterialPageRoute(builder: (c) {
                      return const LoginPage();
                    }));
                  }
                }),
                _buildListTile('登出', Icons.logout_rounded, () async {
                  Navigator.pop(context);
                  if (u.isLogin) {
                    var data = await _httpManager.get('/logout');
                    if (data['code'] == 200) {
                      MsgUtil.primary('退出成功');
                      //退出成功
                      User u = User();
                      context.read<User>().updateUser(u);
                      SpUtil.remove('user');
                    }
                  } else {
                    MsgUtil.warn('你还没登陆呢');
                  }
                }),
              ]),
            ],
          ),
        ),
        body: _buildIndexPage(onTop),
        bottomNavigationBar: const BottomPlayerBar(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

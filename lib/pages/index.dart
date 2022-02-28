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
import 'package:flutter_music_player/widgets/index_drawer.dart';
import 'package:flutter_music_player/widgets/index_header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_music_player/pages/login.dart';
import 'package:flutter_music_player/pages/search.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:sp_util/sp_util.dart';
import 'package:transparent_image/transparent_image.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<PlayList> _playList = [];

  bool showBlur = true; // 是否模糊背景

  DateTime? _lastPressedAt; //上次点击时间

  final ScrollController _controller = ScrollController(); // 滚动控制器

  late HttpManager _httpManager; // http管理器

  AudioPlayerManager audioPlayerManager = AudioPlayerManager.getInstance()!; // 音频播放管理器

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
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: onTop,
              titlePadding: const EdgeInsets.all(0),
              stretchModes: const [StretchMode.zoomBackground],
              background: context.watch<User>().isLogin
                  ? FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      placeholder: kTransparentImage,
                      image: context.watch<User>().backgroundUrl)
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
                          imageUrl: _playList[i].coverImgUrl,
                          width: 55,
                          progressIndicatorBuilder: (c, u, d) =>
                              LinearProgressIndicator(value: d.progress),
                          errorWidget: (c, u, e) => const Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
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
    bool? isCached = SpUtil.haveKey('playList');
    // bool flag = false;
    // print(isCached);

    if (isCached == true) {
      //从本地缓存获取
      if (_playList.isEmpty) {
        //避免重复加载
        setState(() {
          _playList = SpUtil.getObjList<PlayList>('playList', (v) {
            return PlayList.fromJson(v, User.fromJson2(v['creator']));
          })!;
        });
      }
    } else {
      //从网络获取
      var data = await _httpManager.get('/user/playlist?uid=$id');
      if (_playList.isEmpty) {
        //避免重复加载
        setState(() {
          _playList = data['playlist'].map<PlayList>((e) {
            User user = User.fromJson2(e['creator']);
            return PlayList.fromJson(e, user);
          }).toList();
        });
      }
      //放入本地缓存
      await SpUtil.putObjectList('playList', _playList);
    }
  }

  onAccount(User u) {
    if (!u.isLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (c) {
        return const LoginPage();
      })).then((value) {
        if(value == 'success'){
          Navigator.pop(context);
        }
      });
      
      // Navigator.pop(context);
    }
  }

  onLogout(User u) {
    MsgUtil.confirm(context, msg: '确定要退出吗？', onConfirm: () async {
      Navigator.pop(context);
      if (u.isLogin) {
        //退出成功
        User u = User();
        context.read<User>().updateUser(u);
        setState(() {
          _playList = [];
        });
        //清除所有的信息
        SpUtil.clear();
        MsgUtil.primary('退出成功');
      } else {
        MsgUtil.warn(msg: '你还没登陆呢');
      }
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
    // print(context);
    // SpUtil.clear();

    ///显示用户的名称
    ///显示用户的头像
    ///显示用户的id
    // var onTop = InkWell(
    //   onTap: () {
    //     if (u.isLogin) {
    //       MsgUtil.primary('用户已登录');
    //     } else {
    //       Navigator.push(
    //           context, CupertinoPageRoute(builder: (c) => const LoginPage()));
    //     }
    //   },
    //   child: ClipRRect(
    //     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    //     child: BackdropFilter(
    //       filter: showBlur
    //           ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
    //           : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
    //       child: Container(
    //         color: Colors.white.withOpacity(0.3),
    //         padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             CircleAvatar(
    //               radius: 15,
    //               foregroundImage: u.isLogin ? NetworkImage(u.avatarUrl) : null,
    //               child: u.isLogin
    //                   ? null
    //                   : const Text(
    //                       '登录',
    //                       style: TextStyle(fontSize: 11),
    //                     ),
    //             ),
    //             Container(
    //               margin: const EdgeInsets.only(left: 8),
    //               height: 40,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     u.uname,
    //                     style: const TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 14,
    //                         fontWeight: FontWeight.w400),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                   Text(
    //                     'id: ${u.id}',
    //                     style: const TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 10,
    //                         fontWeight: FontWeight.w300),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    //用户歌单更新
    if (u.isLogin) _getUserPlayList(u.id);
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
        drawerEdgeDragWidth: 100,
        drawer: IndexDrawer(
          onLogout: () => onLogout(u),
          onAccount: () => onAccount(u),
        ),
        body: _buildIndexPage(IndexHeader(user: u, showBlur: showBlur)),
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

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

  late num _id; //判断是否需要rebuild

  late HttpManager _httpManager;

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
              background: context.watch<User>().isLogin
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: context.watch<User>().backgroundUrl,
                      errorWidget: (c, u, e) => const Icon(Icons.error))
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

  //自动登录
  _autoLogin() async {
    var user = SpUtil.getObject('user');
    if (user == null) return;
    var data = await _httpManager.get('/login/status?cookie=${user['cookie']}');
    print(data);
    if (data['data']['code'] == 200) {
      User u = User.init(user['uname'], user['id'], user['avatarUrl'],
          user['cookie'], user['isLogin'], user['backgroundUrl']);
      print(u);
      context.read<User>().updateUser(u);
    } else {
      MsgUtil.warn('请重新登录');
    }
  }

  @override
  void initState() {
    _httpManager = HttpManager.getInstance();
    _id = context.read<User>().id;
    _autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User u = context.watch<User>();
    //用户信息头部
    var onTop = InkWell(
      onTap: () {
        if (u.isLogin) {
          MsgUtil.primary('用户已登录');
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (c) => const LoginPage()));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
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
                mainAxisAlignment: MainAxisAlignment.end,
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
    );
    //用户歌单更新
    if (u.id != _id) {
      _getUserPlayList(u.id);
      _id = u.id;
    }
    return Scaffold(
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
    );
  }
}

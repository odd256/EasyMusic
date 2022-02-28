import 'package:animations/animations.dart';
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
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:sp_util/sp_util.dart';

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

  AudioPlayerManager audioPlayerManager =
      AudioPlayerManager.getInstance()!; // 音频播放管理器

  //显示歌单
  _buildIndexPage(User u) => CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          //头部
          IndexHeader(
            user: u,
            showBlur: showBlur,
            onTapUserInfo: () => onTapUserInfo(u),
          ),

          //歌单列表
          SliverPrototypeExtentList(
            delegate: SliverChildBuilderDelegate(
                (c, i) => KeepAliveWrapper(
                      keepAlive: true,
                      child: IndexListTile(
                        playList: _playList[i],
                      ),
                    ),
                childCount: _playList.length),
            prototypeItem: const ListTile(
              title: Text(''),
              subtitle: Text(''),
              leading: Icon(Icons.print_rounded),
            ),
          )
        ],
      );

  //获取用户歌单
  _getUserPlayList(id) async {
    bool? isCached = SpUtil.haveKey('playList');

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

  onTapUserInfo(User user) {
    if (user.isLogin) {
      MsgUtil.primary('用户已登录');
    } else {
      Navigator.push(
          context, CupertinoPageRoute(builder: (c) => const LoginPage()));
    }
  }

  onAccount(User u) {
    if (!u.isLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (c) {
        return const LoginPage();
      })).then((value) {
        // Navigator.pop(context);
      });
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
        body: _buildIndexPage(u),
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

class IndexListTile extends StatelessWidget {
  final PlayList playList;

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  const IndexListTile({Key? key, required this.playList}) : super(key: key);

  void _showMarkedAsDoneSnackbar(context, bool? isMarkedAsDone) {
    if (isMarkedAsDone ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Marked as done!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: _transitionType,
      tappable: false,
      closedElevation: 0.0,
      onClosed: (bool? v)=>_showMarkedAsDoneSnackbar(context, v),
      closedShape: const RoundedRectangleBorder(),
      openBuilder: (_, __) => PlayListPage(
        title: '歌单详情',
        playList: playList,
      ),
      closedBuilder: (context, openContainer) {
        return ListTile(
          onTap: openContainer,
          title: Text(
            playList.name,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CachedNetworkImage(
            imageUrl: playList.coverImgUrl,
            width: 55,
            progressIndicatorBuilder: (c, u, d) =>
                LinearProgressIndicator(value: d.progress),
            errorWidget: (c, u, e) => const Icon(Icons.error_rounded),
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
          subtitle: Text('${playList.trackCount} 首'),
        );
      },
    );
  }
}

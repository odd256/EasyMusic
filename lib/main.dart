import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/index.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance!.imageCache!.maximumSizeBytes = 1024 * 1024 * 300;
  await SpUtil.getInstance();
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，
    // 写在组件渲染之前，MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AudioPlayerManager _playerManager;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _playerManager = AudioPlayerManager.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {
    // print(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User()),
        StreamProvider(
            create: (context) => _playerManager.player?.playerStateStream,
            initialData: _playerManager.player?.playerState),
        StreamProvider(
            create: (_) => _playerManager.player?.sequenceStateStream,
            initialData: _playerManager.player?.sequenceState)
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryIconTheme: const IconThemeData(color: Colors.black),
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.pink),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black)),
        ),
        debugShowCheckedModeBanner: false,
        title: '我的音乐',
        home: const SplashPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

/// APP启动页
/// 可以做一些APP初始化的工作
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _httpManager = HttpManager.getInstance();

  //自动登录
  _autoLogin() async {
    var user = SpUtil.getObject('user');
    if (user == null) {
      //没有登录过
      MsgUtil.tip(msg: '请先登录 :)');
      Future.delayed(const Duration(milliseconds: 1500), () {
        //重新定向至主页
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const IndexPage()));
      });
      return;
    }
    //==============================
    //登录过
    try {
      var data =
          await _httpManager.get('/login/status?cookie=${user['cookie']}');
      if (data['data']['code'] == 200) {
        User u = User.init(user['nickname'], user['userId'], user['avatarUrl'],
            user['cookie'], user['isLogin'], user['backgroundUrl']);
        context.read<User>().updateUser(u);
      } else {
        MsgUtil.warn(msg: '请重新登录');
      }
    }on DioError catch (e) {
      print(e);
      MsgUtil.warn(msg: '发生了一些错误');
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      // 重新定向至主页
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const IndexPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: FlutterLogo(
          size: 250,
          textColor: Colors.white,
          duration: Duration(milliseconds: 3000),
          style: FlutterLogoStyle.horizontal,
          curve: Curves.bounceIn,
        ),
      ),
    );
  }
}

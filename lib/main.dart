import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/index.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  @override
  void initState() {
    super.initState();
    _playerManager = AudioPlayerManager.getInstance()!;
  }

  @override
  Widget build(BuildContext context) {


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
        home: const IndexPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

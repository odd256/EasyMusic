import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/index.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayerManager.getInstance()!.audioPlayer;
  }

  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => User()),
        StreamProvider(
            create: (context) => _player.playerStateStream,
            initialData: _player.playerState),
        StreamProvider(
            create: (_) => _player.sequenceStateStream,
            initialData: _player.sequenceState)
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/album.dart';
import 'package:flutter_music_player/models/artist.dart';
import 'package:flutter_music_player/models/audio_metadata.dart';
import 'package:flutter_music_player/models/play_list.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/search.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayListPage extends StatefulWidget {
  final PlayList playList;

  const PlayListPage({Key? key, required this.playList}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  List _songs = [];
  late final HttpManager _httpManager;

  late final AudioPlayerManager _playerManager;

  //获取歌单中的歌曲
  _getPlayListSongs() async {
    var data = await _httpManager.get(
        '/playlist/detail?id=${widget.playList.id}&cookie=${context.read<User>().cookie}');
    if (data['code'] == 200) {
      setState(() {
        _songs = data['playlist']['tracks'].map<Song>((e) {
          final Album al = Album.fromJson(e['al']);
          final List<Artist> ar =
              e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
          return Song.fromJson(e, ar, al);
        }).toList();
        print('_getPlayListSongs: $data');
      });
    }
  }

  //播放歌曲
  playMusic(Song song)async {
    //先根据id查歌曲url
    var data = await _httpManager
        .get('/song/url?id=${song.id}&cookie=${context.read<User>().cookie}');
    if (data['code'] == 200) {
      var d = data['data'][0];
      print(d);
      //查完信息开始播放
      try {
        var playlist = _playerManager.playList;
        playlist.add(
          AudioSource.uri(
            Uri.parse(d['url']),
            tag: AudioMetadata(song: song),
          ),
        );
        // await _player.setUrl(data['url']);
        print(playlist.length - 1);
        if (playlist.length >= 0) {
          _playerManager.audioPlayer
              .seek(Duration.zero, index: playlist.length - 1);
        }
      } catch (e) {
        print(e);
        MsgUtil.warn('播放出错');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _httpManager = HttpManager.getInstance();
    _playerManager = AudioPlayerManager.getInstance()!;
    _getPlayListSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
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
                  icon: const Icon(Icons.search_rounded)),
            ],
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                widget.playList.name,
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              background: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.playList.coverImgUrl,
                  errorWidget: (c, u, e) => const Icon(Icons.error)),
            ),
          ),
          SliverPrototypeExtentList(
            delegate: SliverChildBuilderDelegate(
                (c, i) => ListTile(
                      onTap: () {
                        //播放歌曲
                        playMusic(_songs[i]);
                      },
                      title: Text(
                        _songs[i].name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Container(
                        child: Center(
                            child: Text(
                          '${i + 1}',
                          style: const TextStyle(fontSize: 18),
                        )),
                        height: 50,
                        width: 50,
                      ),
                      subtitle: Text(_songs[i].showArtist()),
                    ),
                childCount: _songs.length),
            prototypeItem: const ListTile(
              title: Text(''),
              subtitle: Text(''),
              leading: Icon(Icons.print),
            ),
          )
        ],
      ),
      bottomNavigationBar: const BottomPlayerBar(),
    );
  }
}

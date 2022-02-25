import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/album.dart';
import 'package:flutter_music_player/models/artist.dart';
import 'package:flutter_music_player/models/play_list.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/pages/search.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:provider/provider.dart';

class PlayListPage extends StatefulWidget {
  final PlayList playList;

  const PlayListPage({Key? key, required this.playList}) : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  List<Song> _songs = [];
  late final HttpManager _httpManager;

  late final AudioPlayerManager _playerManager;

  final _token = CancelToken();

  bool firstPlay = true; // 是否是第一次播放

  //获取歌单中的歌曲
  _getPlayListSongs() async {
    var data = await _httpManager.get(
        '/playlist/detail?id=${widget.playList.id}&cookie=${context.read<User>().cookie}',
        cancelToken: _token);
    if (data['code'] == 200) {
      setState(() {
        _songs = data['playlist']['tracks'].map<Song>((e) {
          final Album al = Album.fromJson(e['al']);
          final List<Artist> ar =
              e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
          return Song.fromJson(e, ar, al);
        }).toList();
      });
    }
  }

  //播放歌曲
  playMusic(i) async {
    if (firstPlay) {
      _playerManager.playlist = _songs;
      firstPlay = false;
    }
    _playerManager.play(index: i);
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
          _songs.isEmpty
              ? const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                )
              : SliverPrototypeExtentList(
                  delegate: SliverChildBuilderDelegate(
                      (c, i) => ListTile(
                            onTap: () {
                              //播放歌曲
                              playMusic(i);
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

  @override
  void dispose() {
    super.dispose();
    _httpManager.cancelRequest(_token);
  }
}

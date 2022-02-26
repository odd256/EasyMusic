import 'dart:ui';

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
  final title;

  final PlayList playList;

  const PlayListPage({Key? key, required this.playList, required this.title})
      : super(key: key);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  List<Song> _songs = [];
  late final HttpManager _httpManager;

  late final AudioPlayerManager _playerManager;

  final _token = CancelToken();

  bool firstPlay = true; // 是否是第一次播放
  bool showListInfo = false; // 是否显示歌单信息

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
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            // 滑动到顶端时会固定住
            stretch: true,
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
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
            expandedHeight: 320.0,
            flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: GestureDetector(
                  onTapDown: (details) {
                    if (!showListInfo) {
                      setState(() {
                        showListInfo = !showListInfo;
                      });
                    }
                  },
                  onTapUp: (details) {
                    if (showListInfo) {
                      setState(() {
                        showListInfo = !showListInfo;
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //防遮挡
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: CachedNetworkImage(
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: widget.playList.coverImgUrl,
                            errorWidget: (c, u, e) => const Icon(Icons.error)),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(),
                      ),
                      if (showListInfo) Card(
                              elevation: 15,
                              color: Colors.black.withOpacity(0.8),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14.0))),
                              child: const SizedBox(
                                height: 170,
                                width: 300,
                              )) else Material(
                              type: MaterialType.transparency,
                              child: Container(),
                            )
                    ],
                  ),
                )),
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

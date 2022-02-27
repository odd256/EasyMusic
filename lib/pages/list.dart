import 'dart:ui';

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
import 'package:flutter_music_player/widgets/playlist_details.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:transparent_image/transparent_image.dart';

class PlayListPage extends StatefulWidget {
  final String title;

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

  // bool hasTimeout = false; // 是否超时

  //获取歌单中的歌曲
  _getPlayListSongs() async {
    // SpUtil.remove('playListSongs${widget.playList.id}');
    bool? isCached = SpUtil.haveKey('playListSongs${widget.playList.id}');
    // bool? isCached = false;
    // if (hasTimeout) {
    //   setState(() {
    //     hasTimeout = false;
    //   });
    // }
    if (isCached == true) {
      //从缓存中获取
      print('从缓存中获取');
      var s = SpUtil.getObjList<Song>('playListSongs${widget.playList.id}', (v) {
        print(v);
        List<Artist> artists =
            v['artist'].map<Artist>((e) => Artist.fromJson(e))?.toList();
        return Song.fromJson(v, artists, Album.fromJson(v['album']));
      })!;
      setState(() {
        _songs = s;
      });
    } else {
      //从网络获取
      try {
        var data = await _httpManager.get(
            '/playlist/detail?id=${widget.playList.id}&cookie=${context.read<User>().cookie}',
            cancelToken: _token);
        if (data != null && data['code'] == 200) {
          setState(() {
            _songs = data['playlist']['tracks'].map<Song>((e) {
              final Album al = Album.fromJson(e['al']);
              final List<Artist> ar =
                  e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
              return Song.fromJson(e, ar, al);
            }).toList();
            //缓存
            SpUtil.putObjectList('playListSongs${widget.playList.id}', _songs);
          });
        }
      } catch (e) {
        print('+++++++++++++++++++++++++++++++++++++++++++++++++');
        print(e);
        // if (!hasTimeout) {
        //   setState(() {
        //     hasTimeout = true;
        //   });
        // }
      }
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
                background: Stack(
              alignment: Alignment.center,
              children: [
                FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  image: widget.playList.coverImgUrl,
                  placeholder: kTransparentImage,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                PlaylistDetails(
                  playlistInfo: widget.playList,
                ),
              ],
            )),
          ),
          // if (hasTimeout && _songs.isEmpty)
          //   SliverToBoxAdapter(
          //       child: Center(
          //     child: TextButton(
          //       onPressed: () {
          //         _getPlayListSongs();
          //       },
          //       child: const Text(
          //         '获取歌单失败，请重试',
          //         style: TextStyle(color: Colors.blue),
          //       ),
          //     ),
          //   ))
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
                            leading: SizedBox(
                              child: Center(
                                  child: Text(
                                '${i + 1}',
                                style: const TextStyle(fontSize: 20),
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
                ),
          // _songs.isEmpty
          //     ? const SliverToBoxAdapter(
          //         child: LinearProgressIndicator(),
          //       )
          //     : SliverPrototypeExtentList(
          //         delegate: SliverChildBuilderDelegate(
          //             (c, i) => ListTile(
          //                   onTap: () {
          //                     //播放歌曲
          //                     playMusic(i);
          //                   },
          //                   title: Text(
          //                     _songs[i].name,
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                   leading: SizedBox(
          //                     child: Center(
          //                         child: Text(
          //                       '${i + 1}',
          //                       style: const TextStyle(fontSize: 20),
          //                     )),
          //                     height: 50,
          //                     width: 50,
          //                   ),
          //                   subtitle: Text(_songs[i].showArtist()),
          //                 ),
          //             childCount: _songs.length),
          //         prototypeItem: const ListTile(
          //           title: Text(''),
          //           subtitle: Text(''),
          //           leading: Icon(Icons.print),
          //         ),
          //       )
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

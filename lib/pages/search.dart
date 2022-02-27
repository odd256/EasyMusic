import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/album.dart';
import 'package:flutter_music_player/models/artist.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/widgets/bottom_player_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Song> _songs = [];
  final HttpManager _httpManager = HttpManager.getInstance();
  final AudioPlayerManager _playerManager = AudioPlayerManager.getInstance()!;

  _buildListView() {
    //每个列表显示
    return ListView.builder(
      prototypeItem: const ListTile(
        title: Text('1'),
      ),
      itemBuilder: (c, i) {
        return ListTile(
          onTap: () async {
            //点击播放音乐
            //检查picUrl是否存在，不存在要获取
            if (_songs[i].album?.picUrl == null) {
              final ad = await _httpManager
                  .get('/album?id=${_songs[i].album?.id}', withLoading: false);
              if (ad['code'] == 200) {
                _songs[i].album = Album.fromJson(ad['album']);
              }
            }
            _playerManager.playlist.add(_songs[i]);
            _playerManager.play(index: _playerManager.playlist.length - 1);
          },
          title: Text(_songs[i].name),
          // subtitle: Text(_songs[i].artist[0].name),
          subtitle: Text(_songs[i].showArtist()),
        );
      },
      itemCount: _songs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: TextField(
            onSubmitted: (v) async {
              //发送网络请求，搜索歌曲
              var data = await _httpManager.get('/search?keywords=$v');
              if (data['code'] == 200) {
                List<Song> s = data['result']['songs'].map<Song>((e) {
                  List<Artist> artist = e['artists']
                      .map<Artist>((q) => Artist.fromJson(q))
                      .toList();
                  Album album = Album.fromJson(e['album']);
                  return Song.fromJson(e, artist, album);
                }).toList();
                setState(() {
                  _songs = s;
                });
              }
            },
            autofocus: true,
            cursorColor: Colors.black,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 0.0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0)),
                icon: Icon(Icons.search)),
          ),
        ),
      ),
      body: _buildListView(),
      bottomNavigationBar: const BottomPlayerBar(),
    );
  }
}

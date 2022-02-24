import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/artist.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/utils/audio_player_manager.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _songs = [];
  final HttpManager _httpManager = HttpManager.getInstance();
  final AudioPlayerManager _audioPlayerManager =
      AudioPlayerManager.getInstance()!;

  String _showAllArtist(artists) {
    // 显示所有的艺术家
    String content = "";
    for (int i = 0; i < artists.length; i++) {
      content += artists[i].name;
      if (i != artists.length - 1) content += '/';
    }
    return content;
  }

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
            // AudioPlayer audioPlayer = _audioPlayerManager.audioPlayer;
            // print('/song/url?id=${_songs[i].id}');
            // var res = await _req.get('/song/url?id=${_songs[i].id}');
            // print(res.data['data']);
            // if (res.data['data'][0]['code'] == 200) {
            //   int result = await audioPlayer.play(res.data['data'][0]['url']);
            //   if (result == 1) {
            //     // 成功播放
            //   }
            // } else {
            //   MsgUtil.warn('无法播放');
            // }
          },
          title: Text(_songs[i].name),
          // subtitle: Text(_songs[i].artist[0].name),
          subtitle: Text(_showAllArtist(_songs[i].artist)),
        );
      },
      itemCount: _songs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Colors.grey,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: TextField(
            onSubmitted: (v) async {
              //发送网络请求，搜索歌曲
              var data = await _httpManager.get('/search?keywords=$v');
              setState(() {
                _songs = data['result']['songs'].map((e) {
                  var artist =
                      e['artists'].map((q) => Artist.fromJson(q)).toList();
                  return Song.fromJson(e, artist, null);
                }).toList();
              });
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
                icon: Icon(Icons.search_rounded)),
          ),
        ),
      ),
      body: _buildListView(),
    );
  }
}

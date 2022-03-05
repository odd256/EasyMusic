/*
 * @Creator: Odd
 * @Date: 2022-02-27 19:03:22
 * @LastEditTime: 2022-03-01 01:29:18
 * @FilePath: \flutter_music_player\lib\widgets\playlist_details.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/play_list.dart';

class PlaylistDetails extends StatelessWidget {
  final PlayList playlistInfo;
  const PlaylistDetails({Key? key, required this.playlistInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 170,
            width: 170,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10.0)
                ],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: NetworkImage(playlistInfo.coverImgUrl))),
          ),
          Container(
            width: 200,
            height: 170,
            padding: const EdgeInsets.only(left: 18),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlistInfo.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 15,
                          foregroundImage:
                              NetworkImage(playlistInfo.creator.avatarUrl)),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            playlistInfo.creator.uname,
                            style: const TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                  Text('共收录${playlistInfo.trackCount}首歌',
                      style: const TextStyle(fontSize: 14)),
                ]),
          )
        ],
      ),
    );
  }
}

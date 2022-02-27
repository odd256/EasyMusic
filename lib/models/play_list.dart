/*
 * @Creator: Odd
 * @Date: 2022-02-09 15:54:49
 * @LastEditTime: 2022-02-27 20:19:14
 * @FilePath: \flutter_music_player\lib\models\play_list.dart
 */
//歌单
import 'package:flutter_music_player/models/user.dart';

class PlayList {
  num id;
  String coverImgUrl;
  String name;
  num trackCount;
  User creator;

  PlayList(this.id, this.coverImgUrl, this.name, this.trackCount, this.creator);

  PlayList.fromJson(Map<String, dynamic> json, this.creator)
      : id = json['id'],
        coverImgUrl = json['coverImgUrl'],
        name = json['name'],
        trackCount = json['trackCount'];
}

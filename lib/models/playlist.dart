/*
 * @Creator: Odd
 * @Date: 2022-04-13 17:01:24
 * @LastEditTime: 2022-04-13 21:24:44
 * @FilePath: \flutter_easymusic\lib\models\playlist.dart
 */
import 'package:flutter_easymusic/models/creator.dart';

class Playlist {
  num id;
  String coverImgUrl;
  String name;
  num trackCount;
  Creator creator;

  Playlist(this.id, this.coverImgUrl, this.name, this.trackCount, this.creator);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = creator.toJson();
    return {
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'creatorId': creator.userId,
      'trackCount': trackCount,
      'creator': map,
    };
  }

  Playlist.fromJson(Map<dynamic, dynamic> json, this.creator)
      : id = json['id'],
        coverImgUrl = json['coverImgUrl'],
        name = json['name'],
        trackCount = json['trackCount'];
}
/*
 * @Creator: Odd
 * @Date: 2022-04-14 12:12:52
 * @LastEditTime: 2022-04-16 20:56:29
 * @FilePath: \flutter_easymusic\lib\models\song.dart
 */
import 'package:flutter_easymusic/models/album.dart';
import 'package:flutter_easymusic/models/artist.dart';

class Song {
  num id=-1;
  String name='';
  List<Artist> artists = [];
  Album? album;

  Song(this.name, this.id, this.artists, this.album);

  Song.fromJson(Map<dynamic, dynamic> json, this.artists, this.album)
      : name = json['name'],
        id = json['id'];

  Map<dynamic, dynamic> toJson() => {
        'name': name,
        'id': id,
        'artist': artists,
        'album': album,
      };


  @override
  String toString() {
    return 'Song{id: $id, name: $name, artist: $artists, album: $album}';
  }

}
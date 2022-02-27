/*
 * @Creator: Odd
 * @Date: 2022-02-05 06:28:51
 * @LastEditTime: 2022-02-28 03:46:18
 * @FilePath: \flutter_music_player\lib\models\song.dart
 */
import 'package:flutter_music_player/models/album.dart';
import 'package:flutter_music_player/models/artist.dart';
//歌曲
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

  String showArtist() {
    String s = '';
    for (int i = 0; i < artists.length; i++) {
      s += artists[i].name;
      if (artists.length - 1 != i) {
        s += '/';
      }
    }
    return s;
  }
}

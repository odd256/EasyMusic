import 'package:flutter_music_player/models/album.dart';
import 'package:flutter_music_player/models/artist.dart';
//歌曲
class Song {
  num id=-1;
  String name='';
  List<Artist> artist=[];
  Album? album;

  Song(this.name, this.id, this.artist, this.album);

  Song.fromJson(Map<String, dynamic> json, this.artist, this.album)
      : name = json['name'],
        id = json['id'];


  @override
  String toString() {
    return 'Song{id: $id, name: $name, artist: $artist, album: $album}';
  }

  String showArtist() {
    String s = '';
    for (int i = 0; i < artist.length; i++) {
      s += artist[i].name;
      if (artist.length - 1 != i) {
        s += '/';
      }
    }
    return s;
  }
}

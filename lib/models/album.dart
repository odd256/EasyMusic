/*
 * @Creator: Odd
 * @Date: 2022-02-13 10:04:43
 * @LastEditTime: 2022-02-28 03:38:03
 * @FilePath: \flutter_music_player\lib\models\album.dart
 */
//专辑
class Album {
  String? name;
  num id;
  String? picUrl;

  Album(
    this.name,
    this.id,
    this.picUrl,
  );

  Album.fromJson(json)
      : name = json['name'],
        id = json['id'],
        picUrl = json['picUrl'];

  Map<dynamic, dynamic> toJson() => {
        'name': name,
        'id': id,
        'picUrl': picUrl,
      };

  @override
  String toString() {
    return 'Album{name: $name, id: $id, coverUrl: $picUrl}';
  }
}

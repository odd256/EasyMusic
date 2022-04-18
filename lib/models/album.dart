/*
 * @Creator: Odd
 * @Date: 2022-04-14 12:14:11
 * @LastEditTime: 2022-04-14 12:14:12
 * @FilePath: \flutter_easymusic\lib\models\album.dart
 */
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
/*
 * @Creator: Odd
 * @Date: 2022-02-05 06:29:00
 * @LastEditTime: 2022-02-28 03:23:33
 * @FilePath: \flutter_music_player\lib\models\artist.dart
 */
//艺术家
class Artist {
  final num id;
  final String name;
  final String? imgUrl;

  Artist(this.name, this.imgUrl, this.id);

  Artist.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imgUrl = json['img1v1Url'],
        id = json['id'];

  Map<dynamic, dynamic> toJson() => {
        'name': name,
        'img1v1Url': imgUrl,
        'id': id,
      };

  @override
  String toString() {
    return 'Artist{name: $name, imgUrl: $imgUrl}';
  }
}

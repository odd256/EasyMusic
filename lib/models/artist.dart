/*
 * @Creator: Odd
 * @Date: 2022-04-14 12:13:45
 * @LastEditTime: 2022-04-14 12:13:46
 * @FilePath: \flutter_easymusic\lib\models\artist.dart
 */
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
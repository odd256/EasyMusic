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

  @override
  String toString() {
    return 'Artist{name: $name, imgUrl: $imgUrl}';
  }
}

//专辑
class Album {
  String name;
  num id;
  String picUrl;

  Album.fromJson(json)
      : name = json['name'],
        id = json['id'],
        picUrl = json['picUrl'];

  @override
  String toString() {
    return 'Album{name: $name, id: $id, coverUrl: $picUrl}';
  }
}

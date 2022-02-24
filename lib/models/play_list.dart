class PlayList {
  num id;
  String coverImgUrl;
  String name;
  num trackCount;

  PlayList(this.id, this.coverImgUrl, this.name, this.trackCount);

  PlayList.fromJson(Map<String, dynamic> json)
      : id = json['id'],coverImgUrl = json['coverImgUrl'],
        name = json['name'],
        trackCount = json['trackCount'];
}

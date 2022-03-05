/*
 * @Creator: Odd
 * @Date: 2022-02-09 15:54:49
 * @LastEditTime: 2022-03-05 02:09:23
 * @FilePath: \flutter_music_player\lib\models\play_list.dart
 */
//歌单
import 'package:flutter_music_player/models/user.dart';

// const tablePlaylist = 'playlist';
// const columnId = 'id';
// const columnName = 'name';
// const columnCoverImgUrl = 'coverImgUrl';
// const columnCreatorID = 'creatorId';
// const columnTrackCount = 'trackCount';
// const columnOwner = 'owner';

class PlayList {
  num id;
  String coverImgUrl;
  String name;
  num trackCount;
  User creator;

  PlayList(this.id, this.coverImgUrl, this.name, this.trackCount, this.creator);

  Map<String, Object> toJson() {
    Map<String, Object> map = creator.toJson();
    return {
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'creatorId': creator.id,
      'trackCount': trackCount,
      'creator': map,
    };
  }

  PlayList.fromJson(Map<dynamic, dynamic> json, this.creator)
      : id = json['id'],
        coverImgUrl = json['coverImgUrl'],
        name = json['name'],
        trackCount = json['trackCount'];
}

// class PlaylistProvider {
//   late Database db;

//   open(String path) async {
//     db = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute('''
//           create table $tablePlaylist (
//             $columnId integer primary key,
//               $columnName text not null,
//               $columnCoverImgUrl text not null,
//               $columnCreatorID integer not null,
//               $columnTrackCount integer not null
//               )''');
//     });
//   }

//   insert(PlayList playlist) async {
//     await db.insert(tablePlaylist, playlist.toJson());
//     return playlist;
//   }

//   delete(int id) async {
//     return await db
//         .delete(tablePlaylist, where: '$columnId = ?', whereArgs: [id]);
//   }

//   update(PlayList playlist) async {
//     return await db.update(tablePlaylist, playlist.toJson(),
//         where: '$columnId = ?', whereArgs: [playlist.id]);
//   }

//   Future close() async => db.close();
// }

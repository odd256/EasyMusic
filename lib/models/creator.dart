/*
 * @Creator: Odd
 * @Date: 2022-04-13 17:02:07
 * @LastEditTime: 2022-04-13 21:23:50
 * @FilePath: \flutter_easymusic\lib\models\creator.dart
 */
class Creator {
  late num userId;
  late String nickname;
  late String avatarUrl;

  Creator({required this.userId, required this.nickname, required this.avatarUrl});

  Creator.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickname = json['nickname'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['nickname'] = nickname;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}

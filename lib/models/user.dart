/*
 * @Creator: Odd
 * @Date: 2022-04-12 16:35:03
 * @LastEditTime: 2022-08-14 02:29:56
 * @FilePath: \EasyMusic\lib\models\user.dart
 */
//用户
import 'dart:io';

class User {
  String uname;
  num id;
  String avatarUrl;
  String cookie;
  String backgroundUrl;

  User(this.uname, this.id, this.avatarUrl, this.cookie, this.backgroundUrl);

  //最常用的转换
  User.fromJson(Map<String, dynamic> json)
      : id = json['account']['id'],
        uname = json['profile']['nickname'],
        avatarUrl = json['profile']['avatarUrl'],
        cookie = json['cookie'],
        backgroundUrl = json['profile']['backgroundUrl'];

  //通过/login/status接口进行数据转换
  User.fromLoginStatusJson(Map<String, dynamic> json, this.cookie)
      : id = json['account']['id'],
        uname = json['profile']['nickname'],
        avatarUrl = json['profile']['avatarUrl'],
        backgroundUrl = json['profile']['backgroundUrl'];
  //将用户信息保存到本地
  User.fromBox(Map<dynamic, dynamic> json)
      : id = json['id'],
        uname = json['uname'],
        avatarUrl = json['avatarUrl'],
        backgroundUrl = json['backgroundUrl'],
        cookie = json['cookie'];

  Map<String, Object> toJson() => <String, Object>{
        'uname': uname,
        'id': id,
        'avatarUrl': avatarUrl,
        'cookie': cookie,
        'backgroundUrl': backgroundUrl
      };

  @override
  String toString() {
    return 'User{uname: $uname, id: $id, avatarUrl: $avatarUrl, cookie: $cookie, backgroundUrl: $backgroundUrl}';
  }
}

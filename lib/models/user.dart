import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//用户
class User with ChangeNotifier {
  String uname = '---';
  num id = -1;
  String avatarUrl = '';
  String cookie = '';
  bool isLogin = false;
  String backgroundUrl = '';

  User();

  User.init(this.uname, this.id, this.avatarUrl, this.cookie, this.isLogin,
      this.backgroundUrl);

  User.fromJson(Map<String, dynamic> json)
      : id = json['account']['id'],
        uname = json['profile']['nickname'],
        avatarUrl = json['profile']['avatarUrl'],
        cookie = json['cookie'],
        isLogin = true,
        backgroundUrl = json['profile']['backgroundUrl'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uname': uname,
        'id': id,
        'avatarUrl': avatarUrl,
        'cookie': cookie,
        'isLogin': isLogin,
        'backgroundUrl': backgroundUrl
      };

  updateUser(User user) {
    //更新user信息
    uname = user.uname;
    id = user.id;
    avatarUrl = user.avatarUrl;
    cookie = user.cookie;
    isLogin = user.isLogin;
    backgroundUrl = user.backgroundUrl;
    notifyListeners();
  }

  @override
  String toString() {
    return 'User{uname: $uname, id: $id, avatarUrl: $avatarUrl, cookie: $cookie, isLogin: $isLogin, backgroundUrl: $backgroundUrl}';
  }
}

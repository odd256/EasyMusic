/*
 * @Creator: Odd
 * @Date: 2022-04-13 14:35:53
 * @LastEditTime: 2022-04-14 22:21:06
 * @FilePath: \flutter_easymusic\lib\services\user_state.dart
 */
import 'package:flutter_easymusic/models/user.dart';
import 'package:get/get.dart';

class UserState extends GetxService {

  final user = User('请登录', 0, '', '', '').obs;
  final isLogin = false.obs; 

  Future<UserState> init() async {
    return this;
  }
}
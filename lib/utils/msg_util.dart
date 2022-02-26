/*
 * @Creator: Odd
 * @Date: 2022-02-09 15:10:10
 * @LastEditTime: 2022-02-26 20:52:15
 * @FilePath: \flutter_music_player\lib\utils\msg_util.dart
 */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MsgUtil {
  static primary(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  static warn(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pinkAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static tip({msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static loadingWidget(){
    return const Center(
      child: LinearProgressIndicator(),
    );
  }
}
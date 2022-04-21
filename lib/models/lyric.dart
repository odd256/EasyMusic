/*
 * @Creator: Odd
 * @Date: 2022-04-21 23:35:55
 * @LastEditTime: 2022-04-21 23:42:24
 * @FilePath: \flutter_easymusic\lib\models\lyric.dart
 */
import 'dart:developer';

class Lyric {
  final Duration startTime;
  final Duration endTime;
  final String lyric;

  Lyric({required this.startTime, required this.endTime, required this.lyric});


  static formatLyrics(String data) {
    data.split('\n').forEach((line) {
      log(line);
      // if(line.isNotEmpty){
      //   final time = line.substring(1, line.indexOf(']'));
      //   final lyric = line.substring(line.indexOf(']') + 1);
      //   print('$time, $lyric');
      // }
    });
  }
}

/*
 * @Creator: Odd
 * @Date: 2022-04-21 23:35:55
 * @LastEditTime: 2022-04-22 00:25:03
 * @FilePath: \flutter_easymusic\lib\models\lyric.dart
 */
import 'dart:developer';

class Lyric {
  final Duration startTime;
  final String lyric;

  Lyric({required this.startTime, required this.lyric});

  static formatLyrics(String data) {
    RegExp reg = RegExp(r'^\[\d{2}');

    return data.split('\n').where((r) => reg.hasMatch(r)).map<Lyric>((line) {
      final st = line.substring(1, line.indexOf(']'));
      final lrc = line.substring(line.indexOf(']') + 1);
      int minuteNum = int.parse(st.substring(0, st.indexOf(':')));
      int secondNum =
          int.parse(st.substring(st.indexOf(':') + 1, st.indexOf('.')));
      int millisecondNum = int.parse(st.substring(st.indexOf('.') + 1));
      return Lyric(
          startTime: Duration(
              minutes: minuteNum,
              seconds: secondNum,
              milliseconds: millisecondNum),
          lyric: lrc);
    }).toList();
  }
}

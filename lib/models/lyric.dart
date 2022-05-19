/*
 * @Creator: Odd
 * @Date: 2022-04-21 23:35:55
 * @LastEditTime: 2022-05-19 12:25:25
 * @FilePath: \flutter_easymusic\lib\models\lyric.dart
 */
class Lyric {
  Duration startTime;
  Duration endTime;
  String lyric;

  Lyric(
      {this.startTime = Duration.zero,
      this.endTime = Duration.zero,
      required this.lyric});

  static formatLyrics(String data) {
    RegExp reg = RegExp(r'^\[\d{2}');

    var r =  data.split('\n').where((r) => reg.hasMatch(r)).map<Lyric>((line) {
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

    // 设置结束时间
    for(int i=0; i<r.length-1; i++) {
      r[i].endTime = r[i+1].startTime;
    }
    r[r.length-1].endTime = const Duration(days: 1);
    return r;
  }
}

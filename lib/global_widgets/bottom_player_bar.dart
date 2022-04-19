/*
 * @Creator: Odd
 * @Date: 2022-04-15 15:00:19
 * @LastEditTime: 2022-04-19 17:46:41
 * @FilePath: \flutter_easymusic\lib\global_widgets\bottom_player_bar.dart
 */

import 'package:flutter/material.dart';

class BottomPlayerBar extends StatelessWidget {
  const BottomPlayerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: -5,
            offset: Offset(0, -5),
          ),
        ],
      ),
      height: 70,
    );
  }
}

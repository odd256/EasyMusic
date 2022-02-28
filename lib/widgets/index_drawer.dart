/*
 * @Creator: Odd
 * @Date: 2022-02-28 14:48:41
 * @LastEditTime: 2022-03-01 01:37:41
 * @FilePath: \flutter_music_player\lib\widgets\index_drawer.dart
 */
import 'package:flutter/material.dart';

class IndexDrawer extends StatelessWidget {
  final GestureTapCallback? onLogout;
  final GestureTapCallback? onAbout;
  final GestureTapCallback? onSetting;
  final GestureTapCallback? onAccount;

  const IndexDrawer(
      {Key? key, this.onLogout, this.onAbout, this.onSetting, this.onAccount})
      : super(key: key);

  _buildListTile(String title, IconData icon, {onTapAction}) => ListTile(
        onTap: onTapAction,
        leading: Icon(icon),
        title: Text(title),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF5F5F5),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildListTile('关于', Icons.announcement_rounded,
                      onTapAction: onAbout),
                  _buildListTile('设置', Icons.settings_rounded, onTapAction: onSetting),
                  _buildListTile('账号', Icons.person_add,
                      onTapAction: onAccount),
                  _buildListTile('登出', Icons.logout_rounded, onTapAction: onLogout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

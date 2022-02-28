/*
 * @Creator: Odd
 * @Date: 2022-02-28 16:12:08
 * @LastEditTime: 2022-03-01 00:23:56
 * @FilePath: \flutter_music_player\lib\widgets\index_header.dart
 */
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/user.dart';
import '../pages/search.dart';

class IndexHeader extends StatelessWidget {
  final User user;
  final GestureTapCallback? onTapUserInfo;
  final bool showBlur;
  const IndexHeader(
      {Key? key,
      required this.user,
      this.onTapUserInfo,
      required this.showBlur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      // 滑动到顶端时会固定住
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) {
                return const SearchPage();
              }),
            );
          },
          icon: const Icon(Icons.search_rounded),
        )
      ],
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: IndexUserInfo(
          user: user,
          showBlur: showBlur,
          onTapUserInfo: onTapUserInfo,
        ),
        titlePadding: const EdgeInsets.all(0),
        stretchModes: const [StretchMode.zoomBackground],
        background: context.watch<User>().isLogin
            ? FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                placeholder: kTransparentImage,
                image: context.watch<User>().backgroundUrl)
            : Container(
                color: Colors.white,
              ),
      ),
    );
  }
}

class IndexUserInfo extends StatelessWidget {
  final User user;
  final GestureTapCallback? onTapUserInfo;
  final bool showBlur;

  const IndexUserInfo(
      {Key? key,
      required this.user,
      this.onTapUserInfo,
      required this.showBlur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapUserInfo,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: showBlur
              ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            color: Colors.white.withOpacity(0.3),
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  foregroundImage:
                      user.isLogin ? NetworkImage(user.avatarUrl) : null,
                  child: user.isLogin
                      ? null
                      : const Text(
                          '登录',
                          style: TextStyle(fontSize: 11),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.uname,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'id: ${user.id}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w300),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

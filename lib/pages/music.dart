/*
 * @Creator: Odd
 * @Date: 2022-02-26 03:05:37
 * @LastEditTime: 2022-03-01 01:37:02
 * @FilePath: \flutter_music_player\lib\pages\music.dart
 */
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/widgets/music_player_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class MusicPage extends StatefulWidget {
  final Song song;

  const MusicPage(this.song, {Key? key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FadeInImage.memoryNetwork(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: '${widget.song.album?.picUrl}'),
        //防遮挡
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140,
            color: Colors.black26,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 70),
            height: 250,
            width: 250,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: double.infinity,
              imageUrl: '${widget.song.album?.picUrl}',
              errorWidget: (c, u, e) => const Icon(Icons.error_rounded),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10.0)
                  ],
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              // TODO: 打开歌词界面
            },
          ),
        ),
        const Align(
            alignment: Alignment.bottomCenter, child: MusicPlayerController()),
      ],
    );
  }
}

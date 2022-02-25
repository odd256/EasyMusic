import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/song.dart';
import 'package:flutter_music_player/widgets/music_player_controller.dart';

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
        CachedNetworkImage(
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
            imageUrl: '${widget.song.album?.picUrl}',
            errorWidget: (c, u, e) => const Icon(Icons.error)),
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
                errorWidget: (c, u, e) => const Icon(Icons.error))),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              // TODO: 打开歌词界面
            },
          ),
        ),
        const Align(
            alignment: Alignment.bottomCenter, child: MusicPlayerController())
      ],
    );
  }
}

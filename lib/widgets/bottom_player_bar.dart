// /*
//  * @Creator: Odd
//  * @Date: 2022-04-15 15:00:19
//  * @LastEditTime: 2022-04-15 15:13:12
//  * @FilePath: \flutter_easymusic\lib\widgets\bottom_player_bar.dart
//  */
// import 'package:flutter/material.dart';
// import 'package:flutter_easymusic/controllers/audio_controller.dart';
// import 'package:get/get.dart';

// class BottomPlayerBar extends StatelessWidget {
//   const BottomPlayerBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();

//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_){
//         return Stack(
//           alignment: AlignmentDirectional.centerStart,
//           children: [
//             SizedBox(
//                 height: 70,
//                 width: 70,
//                 child: sequence?.isEmpty ?? true
//                     ? const Icon(
//                         Icons.album_rounded,
//                         size: 50,
//                       )
//                     : CachedNetworkImage(imageUrl: metadata.album.picUrl)),
//             Positioned(
//               left: 90,
//               child: SizedBox(
//                   width: 240,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         sequence?.isEmpty ?? true ? '' : metadata.name,
//                         style:
//                             const TextStyle(fontSize: 20, color: Colors.black),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         sequence?.isEmpty ?? true
//                             ? ''
//                             : metadata.showArtist(),
//                         style: const TextStyle(color: Colors.black),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   )),
//             ),
//             Material(
//               type: MaterialType.transparency,
//               child: SizedBox(
//                   height: 70,
//                   child: InkWell(
//                     onTap: sequence?.isEmpty ?? true ? null : onPressMusicBar,
//                   )),
//             ),
//             Positioned(
//               right: 10,
//               child: Row(
//                 children: [
//                   if (processingState == ProcessingState.loading ||
//                       processingState == ProcessingState.buffering)
//                     const CircularProgressIndicator()
//                   else if (playing != true)
//                     IconButton(
//                       icon: const Icon(Icons.play_arrow_rounded),
//                       onPressed: sequence?.isEmpty ?? true
//                           ? null
//                           : _playerManager.play,
//                     )
//                   else if (processingState != ProcessingState.completed)
//                     IconButton(
//                       icon: const Icon(Icons.pause_rounded),
//                       onPressed: _playerManager.pause,
//                     )
//                   else
//                     IconButton(
//                       icon: const Icon(Icons.replay_rounded),
//                       onPressed: _playerManager.seek(Duration.zero),
//                     ),
//                   IconButton(
//                       onPressed: () {
//                         // TODO: 在这里显示播放列表
//                       },
//                       icon: const Icon(Icons.view_list_rounded)),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

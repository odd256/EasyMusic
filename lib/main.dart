/*
 * @Creator: Odd
 * @Date: 2022-04-11 18:07:24
 * @LastEditTime: 2022-04-17 00:06:26
 * @FilePath: \flutter_easymusic\lib\main.dart
 */
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/bindings/controller_bindings.dart';
import 'package:flutter_easymusic/pages/routes/app_pages.dart';
import 'package:flutter_easymusic/services/playlist_state.dart';
import 'package:flutter_easymusic/services/user_state.dart';
import 'package:flutter_easymusic/services/audio_handler.dart';
import 'package:flutter_easymusic/services/http_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await initService();
  runApp(GetMaterialApp(
    initialBinding: GlobalControllerBinding(),
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.initPage,
    defaultTransition: Transition.fade,
    getPages: AppPages.routes,
  ));
}

initService() async {
  log('--------initService start--------');
  await Get.putAsync(() => initAudioService());
  await Get.putAsync(() => HttpService().init());
  await Get.putAsync(() => UserState().init());
  await Get.putAsync(() => PlaylistState().init());
  await GetStorage.init();
  log('--------initService done--------');
}

// class IndexPage extends StatelessWidget {
//   const IndexPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: const [
//             CurrentSongTitle(),
//             Playlist(),
//             AddRemoveSongButtons(),
//             AudioProgressBar(),
//             AudioControlButtons(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CurrentSongTitle extends StatelessWidget {
//   const CurrentSongTitle({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_) => Padding(
//         padding: const EdgeInsets.only(top: 8.0),
//         child: Text(_.currentSongTitle, style: const TextStyle(fontSize: 40)),
//       ),
//     );
//   }
// }

// class Playlist extends StatelessWidget {
//   const Playlist({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_) => Expanded(
//         child: ListView.builder(
//           itemCount: _.playlist.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_.playlist[index]),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class AddRemoveSongButtons extends StatelessWidget {
//   const AddRemoveSongButtons({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           FloatingActionButton(
//             onPressed: audioController.add,
//             child: const Icon(Icons.add),
//           ),
//           FloatingActionButton(
//             onPressed: audioController.remove,
//             child: const Icon(Icons.remove),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AudioProgressBar extends StatelessWidget {
//   const AudioProgressBar({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_) => ProgressBar(
//         progress: _.progress.current,
//         buffered: _.progress.buffered,
//         total: _.progress.total,
//         onSeek: _.seek,
//       ),
//     );
//   }
// }

// class AudioControlButtons extends StatelessWidget {
//   const AudioControlButtons({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: const [
//           RepeatButton(),
//           PreviousSongButton(),
//           PlayButton(),
//           NextSongButton(),
//           ShuffleButton(),
//         ],
//       ),
//     );
//   }
// }

// class RepeatButton extends StatelessWidget {
//   const RepeatButton({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//         init: audioController,
//         builder: (_) {
//           Icon icon;
//           switch (_.repeatButton) {
//             case RepeatState.off:
//               icon = const Icon(Icons.repeat, color: Colors.grey);
//               break;
//             case RepeatState.repeatSong:
//               icon = const Icon(Icons.repeat_one);
//               break;
//             case RepeatState.repeatPlaylist:
//               icon = const Icon(Icons.repeat);
//               break;
//           }
//           return IconButton(
//             icon: icon,
//             onPressed: _.repeat,
//           );
//         });
//   }
// }

// class PreviousSongButton extends StatelessWidget {
//   const PreviousSongButton({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//         init: audioController,
//         builder: (_) => IconButton(
//               icon: const Icon(Icons.skip_previous),
//               onPressed: (_.isFirstSong) ? null : _.previous,
//             ));
//   }
// }

// class PlayButton extends StatelessWidget {
//   const PlayButton({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_) {
//         switch (_.playButton) {
//           case ButtonState.loading:
//             return Container(
//               margin: const EdgeInsets.all(8.0),
//               width: 32.0,
//               height: 32.0,
//               child: const CircularProgressIndicator(),
//             );
//           case ButtonState.paused:
//             return IconButton(
//               icon: const Icon(Icons.play_arrow),
//               iconSize: 32.0,
//               onPressed: _.play,
//             );
//           case ButtonState.playing:
//             return IconButton(
//               icon: const Icon(Icons.pause),
//               iconSize: 32.0,
//               onPressed: _.pause,
//             );
//         }
//       },
//     );
//   }
// }

// class NextSongButton extends StatelessWidget {
//   const NextSongButton({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//         init: audioController,
//         builder: (_) => IconButton(
//               icon: const Icon(Icons.skip_next),
//               onPressed: (_.isLastSong) ? null : _.next,
//             ));
//   }
// }

// class ShuffleButton extends StatelessWidget {
//   const ShuffleButton({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final audioController = Get.find<AudioController>();
//     return GetBuilder<AudioController>(
//       init: audioController,
//       builder: (_) => IconButton(
//         icon: (_.isShuffleModeEnabled)
//             ? const Icon(Icons.shuffle)
//             : const Icon(Icons.shuffle, color: Colors.grey),
//         onPressed: _.shuffle,
//       ),
//     );
//   }
// }

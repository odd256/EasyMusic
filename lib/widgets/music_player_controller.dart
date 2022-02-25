import 'package:flutter/material.dart';

class MusicPlayerController extends StatefulWidget {
  const MusicPlayerController({Key? key}) : super(key: key);

  @override
  _MusicPlayerControllerState createState() => _MusicPlayerControllerState();
}

class _MusicPlayerControllerState extends State<MusicPlayerController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
        children: [
          const LinearProgressIndicator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.repeat)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.view_list_outlined)),
            ],
          )
        ],
      ),
    );
  }
}

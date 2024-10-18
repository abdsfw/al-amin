import 'package:alaminedu/core/utils/styles.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';

class PlayVideoFromVimeoPrivateVideo extends StatefulWidget {
  const PlayVideoFromVimeoPrivateVideo({
    Key? key,
    required this.title,
    required this.videoID,
  }) : super(key: key);
  final String title;
  final String videoID;
  @override
  State<PlayVideoFromVimeoPrivateVideo> createState() =>
      _PlayVideoFromVimeoPrivateVideoState();
}

class _PlayVideoFromVimeoPrivateVideoState
    extends State<PlayVideoFromVimeoPrivateVideo> {
  late final PodPlayerController controller;

  @override
  void initState() {
    // String videoId = 'your private video id';
    // String token = "f6df4938ec0ead40e7cb15cceef645e1";
    // final Map<String, String> headers = <String, String>{};
    // headers['Authorization'] = 'Bearer $token';

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo(
        "https://vimeo.com/940321503", // '935666989', //"https://vimeo.com/940321503", // "https://player.vimeo.com/video/935666989?h=3eca21b936", //"https://vimeo.com/940321503",

        // widget.videoID,
        // httpHeaders: headers,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title, // widget.name!,
          style: Styles.textStyle18White,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: PodVideoPlayer(controller: controller),
    );
  }
}

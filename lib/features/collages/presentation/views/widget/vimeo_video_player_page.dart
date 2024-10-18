import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/vimeo_player_derbak.dart';
import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class VimeoVideoPlayerPage extends StatelessWidget {
  const VimeoVideoPlayerPage(
      {super.key, required this.title, required this.videoUrl});
  final String title;
  final String videoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title, // widget.name!,
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
      body: SafeArea(
        child: VimeoPlayerDerbak(
          videoId: "935666989",
          headers: {"Authorization": "Bearer f6df4938ec0ead40e7cb15cceef645e1"},
        ),
      ),
      // SafeArea(
      //   child: VimeoPlayer(
      //     videoId: "940321503",

      //   ),
      // ),

      // Center(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 250,
      //         child: VimeoPlayer(
      //           videoId: "940321503",
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      //     SafeArea(
      //   child: VimeoVideoPlayer(
      //     autoPlay: true,

      //     url:
      //         "https://player.vimeo.com/video/935666989?h=3eca21b936", //videoUrl,
      //     // url: _vimeoVideoUrl,
      //     // autoPlay: true,
      //   ),
      // ),
    );
  }
}

import 'dart:io';

import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String? url;
  final String? name;
  final File? videoFile;

  const VideoScreen({super.key, this.url, this.name, this.videoFile});
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    if (widget.videoFile == null) {
      //
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          // '${Constants.kBaseDownloadUrl}${widget.url}',
        ),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ),
        httpHeaders: {
          "Authorization":
              "Bearer ${CasheHelper.getData(key: Constants.kToken)}",
        },
      );
    } else {
      _controller = VideoPlayerController.file(
        widget.videoFile!,
      );
    }
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(
                _controller,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// import 'package:alaminedu/core/utils/styles.dart';
// import 'package:flutter/material.dart';
//
// class VideoPlayer extends StatelessWidget {
//   const VideoPlayer({super.key, required this.url, required this.name});
//   final String url;
//   final String name;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           name,
//           style: Styles.textStyle18White,
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../../../../../constants.dart';
import '../../../../../core/cache/cashe_helper.dart';
import '../../../../../core/utils/encrypt.dart';
import '../../../../../core/utils/styles.dart';

class VideoPlayerScreenTEst3 extends StatefulWidget {
  const VideoPlayerScreenTEst3({
    Key? key,
    required this.url,
    required this.name,
    required this.videoFile,
  }) : super(key: key);
  final String? url;
  final String? name;
  final File? videoFile;
  @override
  State<VideoPlayerScreenTEst3> createState() => _VideoPlayerScreenTEst3State();
}

class _VideoPlayerScreenTEst3State extends State<VideoPlayerScreenTEst3> {
  late VideoPlayerController _videoPlayerController;

  late CustomVideoPlayerController _customVideoPlayerController;
  Timer? _timer;
  double _bottomPosition = 10;
  double _rightPosition = 10;
  late Size _screenSize;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(
          showSeekButtons: true, showFullscreenButton: true);

  void _startTimer() {
    const Duration interval = Duration(seconds: 10);
    _timer = Timer.periodic(interval, (_) {
      // Update the position of the watermark every 10 seconds
      setState(() {
        _bottomPosition = Random().nextDouble() * (_screenSize.height - 50);
        _rightPosition = Random().nextDouble() * (_screenSize.width - 100);
      });
    });
  }

  _VideoPlayerScreenTEst3State();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // _startTimer();

    // String sharedLink = '';
    // String directLink = '';
    // if (widget.videoFile == null) {
    //   // sharedLink = Encryption.decrypt(widget.url!);
    //   // directLink = convertDriveLink(sharedLink);
    // } //
    //

    try {
      if (widget.videoFile == null) {
        // ignore: deprecated_member_use
        _videoPlayerController = VideoPlayerController.network(
            // "${Constants.kDomain}${widget.url}" ?? "",
            "https://api.vimeo.com/videos/935666989?fields=play",
            httpHeaders: {
              "Authorization": "Bearer f6df4938ec0ead40e7cb15cceef645e1",
              // "Accept": "application/vnd.vimeo.*+json;version=3.4"
            })
          ..initialize().then((value) => setState(() {}));
      } else {
        _videoPlayerController = VideoPlayerController.file(
          widget.videoFile!,
        )..initialize().then((_) {
            setState(() {});
          });
      }
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController,
        customVideoPlayerSettings: _customVideoPlayerSettings,
      );
    } catch (e) {}
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _customVideoPlayerController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // String convertDriveLink(String sharedLink) {
  //   if (sharedLink.contains('drivesdk')) {
  //     sharedLink = sharedLink.replaceAll('drivesdk', 'sharing');
  //   }
  //   if (sharedLink.contains('/file/d/') &&
  //       sharedLink.contains('/view?usp=sharing')) {
  //     final startIdx = sharedLink.indexOf('/file/d/') + 8;
  //     final endIdx = sharedLink.indexOf('/view?usp=sharing');
  //     if (startIdx < endIdx) {
  //       final fileId = sharedLink.substring(startIdx, endIdx);
  //       return 'https://drive.google.com/uc?export=download&id=$fileId';
  //     }
  //   }
  //   return sharedLink;
  // }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name!,
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
      body: _customVideoPlayerController
              .videoPlayerController.value.isInitialized
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
                ),
              ),
            )
          : const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'please wait',
                    style: Styles.textStyle15PriCol,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SpinKitThreeBounce(
                    color: AppColor.kPrimaryColor,
                    size: 15,
                    // size: size,
                  ),
                ],
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   VideoPlayerScreen({required this.videoUrl});

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isFullScreen = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: Center(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             _controller.value.isInitialized
//                 ? AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   )
//                 : CircularProgressIndicator(), // Show a loading indicator until the video is initialized
//             _buildControls(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_controller.value.isPlaying) {
//             _controller.pause();
//           } else {
//             _controller.play();
//           }
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }

//   Widget _buildControls() {
//     return _isFullScreen
//         ? Container() // Hide controls when in full screen
//         : Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   _toggleFullScreen();
//                 },
//                 icon: Icon(Icons.fullscreen),
//               ),
//               Expanded(
//                 child: VideoProgressIndicator(
//                   _controller,
//                   allowScrubbing: true,
//                   colors: VideoProgressColors(
//                     playedColor: Colors.red,
//                     backgroundColor: Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           );
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });

//     if (_isFullScreen) {
//       _enterFullScreen();
//     } else {
//       _exitFullScreen();
//     }
//   }

//   void _enterFullScreen() {
//     _controller.pause(); // Pause the video when entering full screen
//     _controller.setVolume(0); // Mute the volume in full screen

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text('Full Screen Video'),
//           ),
//           body: Center(
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _exitFullScreen();
//             },
//             child: Icon(Icons.fullscreen_exit),
//           ),
//         ),
//       ),
//     );
//   }

//   void _exitFullScreen() {
//     _controller.setVolume(1); // Restore volume when exiting full screen
//     _controller.play(); // Resume playing when exiting full screen
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

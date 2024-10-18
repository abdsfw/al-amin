import 'dart:typed_data';

import 'package:alaminedu/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

import '../../../../../core/utils/color_app.dart';

class TestCash extends StatefulWidget {
  const TestCash({super.key});
  @override
  State<TestCash> createState() => _TestCashState();
}

class _TestCashState extends State<TestCash> {
  final videoCacheManager = DefaultCacheManager();
  double count = 0;
  @override
  void initState() {
    super.initState();
  }

// !--------------------------------------------------------------------

  // Future<void> downloadAndSavePdf() async {
  //
  //   final directDownloadUrl =
  //       'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
  //   final response = await http.get(Uri.parse(directDownloadUrl));

  //   if (response.statusCode == 200) {
  //     final appDocDir = await getExternalStorageDirectory();
  //     final encryptedVideoFileName =
  //         'encryptedvideo.aes'; // Change to your desired file name
  //     final encryptedVideo =
  //         new File(appDocDir!.path + '/$encryptedVideoFileName');

  //!.....................................................................................................

  //     File outFile = new File('${appDocDir.path}/newname.mp4');
  //     bool outFileExists = await outFile.exists();

  //     if (!outFileExists) {
  //       await outFile.create();
  //     }

  //     final videoFileContents = await encryptedVideo.readAsBytesSync();

  //     final key = encrypt.Key.fromUtf8('my 32 length key................');
  //     final iv = encrypt.IV.fromLength(16);

  //     final encrypter = encrypt.Encrypter(encrypt.AES(key));

  //     final encryptedFile = encrypt.Encrypted(videoFileContents);
  //     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

  //     final decryptedBytes = latin1.encode(decrypted);
  //     // await outFile.writeAsBytes(decryptedBytes);
  //     final pdfCacheManager = DefaultCacheManager();
  //     await pdfCacheManager.putFile(
  //       "yes", // You can use the URL as the key
  //       decryptedBytes,
  //       fileExtension: 'mp4',
  //     );
  //
  //   }
  // }

// !-----------------------------------------------------------------------

  // Future<void> downloadAndSavePdf() async {
  //
  //   final directDownloadUrl =
  //       'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
  //   final response = await http.get(Uri.parse(directDownloadUrl));

  //   if (response.statusCode == 200) {
  //     final appDocDir = await getExternalStorageDirectory();

  //     final encryptedVideoFileName =
  //         'encryptedvideo.mp4'; // Change to your desired file name
  //     final encryptedVideoFile =
  //         File('${appDocDir!.path}/$encryptedVideoFileName');

  //     // if (!encryptedVideoFile.existsSync()) {
  //     //   // The file doesn't exist, handle this case appropriately.
  //     //   return;
  //     // }
  //
  //     // final outFile = File('${appDocDir.path}/newname.mp4');
  //     await encryptedVideoFile.writeAsBytes(response.bodyBytes);
  //     // bool outFileExists = await outFile.exists();

  //     // if (!outFileExists) {
  //     //   await outFile.create();
  //     // }

  //     final videoFileContents =
  //         encryptedVideoFile.readAsBytesSync(); // Read the bytes
  //     //

  //     final key = encrypt.Key.fromUtf8('my 32 length key................');
  //     final iv = encrypt.IV.fromLength(16);

  //     final encrypter = encrypt.Encrypter(encrypt.AES(key));

  //     final encryptedFile = encrypt.Encrypted(videoFileContents);
  //     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

  //     final decryptedBytes = latin1.encode(decrypted);

  //     // await outFile.writeAsBytes(decryptedBytes);
  //     final pdfCacheManager = DefaultCacheManager();
  //     await pdfCacheManager.putFile(
  //       "yes", // You can use the URL as the key
  //       decryptedBytes,
  //       fileExtension: 'mp4',
  //     );

  //     //
  //   }
  // }

// !-----------------------------------------------------------------------

  // Future<void> downloadAndSavePdf() async {
  //
  //   final directDownloadUrl =
  //       'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
  //   Dio dio = Dio();
  //   final appDocDir = await getApplicationSupportDirectory();
  //   final encryptedVideoFileName =
  //       'encryptedvideo.aes'; // Change to your desired file name
  //   final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');

  //   final response = await dio.download(
  //     directDownloadUrl,
  //     encryptedVideo.path,

  //     onReceiveProgress: (count, total) {
  //       setState(() {
  //         this.count = (count / total);
  //       });
  //     },
  //   );
  //   await encryptedVideo.writeAsBytes();
  //   // response.data;

  //   // final response = await http.get(
  //   //   Uri.parse(directDownloadUrl),
  //   // );

  //   // if (response. == 200) {
  //   // final appDocDir = await getApplicationSupportDirectory();
  //   // final encryptedVideoFileName =
  //   //     'encryptedvideo.aes'; // Change to your desired file name
  //   // final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');

  //   // if (!encryptedVideo.existsSync()) {
  //   //
  //   //   return;
  //   // }

  //   File outFile = File('${appDocDir.path}/newname.mp4');
  //   // bool outFileExists = await outFile.exists();

  //   // if (!outFileExists) {
  //   //   await outFile.create();
  //   // }

  //   try {
  //     // final write = await encryptedVideo.writeAsBytes(response.bodyBytes);
  //     final videoFileContents = await encryptedVideo.readAsBytes();
  //
  //     final key = encrypt.Key.fromUtf8('my 32 length key................');
  //     final iv = encrypt.IV.fromLength(16);

  //     final encrypter = encrypt.Encrypter(encrypt.AES(key));

  //     final encryptedFile = encrypt.Encrypted(videoFileContents);
  //     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

  //     final decryptedBytes = latin1.encode(decrypted);
  //     //

  //     final pdfCacheManager = DefaultCacheManager();
  //     await pdfCacheManager.putFile(
  //       "yes", // You can use the URL as the key
  //       decryptedBytes,
  //       fileExtension: 'mp4',
  //     );
  //     //
  //   } catch (e) {
  //
  //   }
  //   // }
  // }

//! -------------------------------------------------------------

  // Future<void> downloadAndSavePdf() async {
  //
  //   final directDownloadUrl =
  //       'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
  //   final response = await http.get(Uri.parse(directDownloadUrl));

  //   if (response.statusCode == 200) {
  //     final appDocDir = await getApplicationSupportDirectory();
  //     final encryptedVideoFileName =
  //         'encryptedvideo.aes'; // Change to your desired file name
  //     final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');
  //     await encryptedVideo.writeAsBytes(response.bodyBytes);
  //     // if (!encryptedVideo.existsSync()) {
  //     //
  //     //   return;
  //     // }

  //     // File outFile = File('${appDocDir.path}/newname.mp4');
  //     // bool outFileExists = await outFile.exists();

  //     // if (!outFileExists) {
  //     //   await outFile.create();
  //     // }

  //     try {
  //
  //       //

  //       // final videoFileContents = await encryptedVideo.readAsBytes();
  //       //
  //       // final key = encrypt.Key.fromUtf8('my 32 length key................');
  //       // final iv = encrypt.IV.fromLength(16);

  //       // final encrypter = encrypt.Encrypter(encrypt.AES(key));

  //       // final encryptedFile = encrypt.Encrypted(videoFileContents);
  //       // final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

  //       // final decryptedBytes = latin1.encode(decrypted);
  //       //

  //       // final pdfCacheManager = DefaultCacheManager();
  //       // await pdfCacheManager.putFile(
  //       //   "yes", // You can use the URL as the key
  //       //   decryptedBytes,
  //       //   fileExtension: 'mp4',
  //       // );
  //     } catch (e) {
  //
  //     }
  //   }
  // }
//!-----------------------------------------------------
  Future<void> downloadAndSavePdf() async {
    final directDownloadUrl =
        'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
    final response = await http.get(Uri.parse(directDownloadUrl));

    if (response.statusCode == 200) {
      final appDocDir = await getApplicationSupportDirectory();
      final encryptedVideoFileName =
          'encryptedvideo.mp4'; // Change to your desired file name
      final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');

      // if (!encryptedVideo.existsSync()) {
      //
      //   return;
      // }

      // File outFile = File('${appDocDir.path}/newname.mp4');
      // await outFile.create();
      // await outFile.writeAsBytes(response.bodyBytes);
      // bool outFileExists = await outFile.exists();

      // if (!outFileExists) {
      //   await outFile.create();
      // }

      // try{
      await encryptedVideo.writeAsBytes(response.bodyBytes);

      final videoFileContents = await encryptedVideo.readAsBytes();

      final key = encrypt.Key.fromUtf8('my 32 length key................');
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encryptedFile = encrypt.Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

      final decryptedBytes = latin1.encode(decrypted);

//  percentage = write.bytesWritten / videoFileContents.length;

      final pdfCacheManager = DefaultCacheManager();
      await pdfCacheManager.putFile(
        "yes", // You can use the URL as the key
        decryptedBytes,
        fileExtension: 'mp4',
      );
      //
      // } catch (e) {
      //
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          count.toString(),
          style: Styles.textStyle14White,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  // await downloadAndSaveVideo();
                  downloadAndSavePdf();
                },
                child: Icon(Icons.download)),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              final fileInfo = await videoCacheManager.getFileFromCache('yes');
              if (fileInfo != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(videoFile: fileInfo.file),
                  ),
                );
              }
            },
            child: Text("Play Video"),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: LinearPercentIndicator(
              // animation: true,
              // animationDuration: 2000,
              lineHeight: 20,
              barRadius: const Radius.circular(10),
              progressColor: AppColor.kPrimaryColor,
              backgroundColor: Colors.white,
              percent: count,
              center: Text(
                '${(count)}%',
                style: Styles.textStyle14.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final File videoFile;

  VideoScreen({required this.videoFile});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Screen"),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// Future<void> downloadAndSaveVideo() async {
//   final directDownloadUrl =
//       'https://drive.google.com/uc?export=download&id=1dcnvRcm02Oj6JbLXm7bNsm_vJ1WryRCj';
//   final response = await http.get(Uri.parse(directDownloadUrl));
//
//   if (response.statusCode == 200) {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final decryptedPdfFileName = 'nassim.aes';
//     final encryptedPdf = File('${appDocDir.path}/$decryptedPdfFileName');

//     // Decrypt the PDF file
//     final pdfFileContents = await encryptedPdf.readAsBytesSync();

//     final key = encrypt.Key.fromUtf8('my 32 length key................');
//     final iv = encrypt.IV.fromLength(16);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key));

//     final encryptedFile = encrypt.Encrypted(pdfFileContents);
//     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
//     final decryptedBytes = latin1.encode(decrypted);

// Save the decrypted content in the cache
// final pdfCacheManager = DefaultCacheManager();
// await pdfCacheManager.putFile(
//   "yse", // You can use the URL as the key
//   decryptedBytes,
//   fileExtension: 'mp4',
// );
//   }
// }

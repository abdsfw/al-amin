import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class Nassim extends StatefulWidget {
  const Nassim({super.key});

  @override
  State<Nassim> createState() => _NassimState();
}

class _NassimState extends State<Nassim> {
  final videoCacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadAndSavePdf() async {
    final directDownloadUrl =
        'https://drive.google.com/uc?export=download&id=1Csq6Svk20fNrDgINNXie2IDYJYDOkhjp';
    final response = await http.get(Uri.parse(directDownloadUrl));

    if (response.statusCode == 200) {
      // final appDocDir = Directory('storage/emulated/0/Video');
      final appDocDir = await getApplicationSupportDirectory();

      if (await appDocDir.exists()) {
      } else {
        appDocDir.create();
      }
      final encryptedVideoFileName =
          'encryptedvideo.aes'; // Change to your desired file name
      final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');
      await encryptedVideo.writeAsBytes(response.bodyBytes);
      //!.....................................................................................................

      try {
        final videoFileContents = encryptedVideo.readAsBytesSync();
        final key = encrypt.Key.fromUtf8('my 32 length key................');
        final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
        final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: null));

        final encryptedFile = encrypt.Encrypted(videoFileContents);
        final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

        final decryptedBytes = latin1.encode(decrypted);
        final pdfCacheManager = DefaultCacheManager();
        await pdfCacheManager.putFile(
          "yes", // You can use the URL as the key
          decryptedBytes,
          fileExtension: 'mp4',
        );
      } catch (e) {}

      //!

      // await outFile.writeAsBytes(decryptedBytes);
      //
    }
  }

/*
  Future<void> downloadAndSavePdf() async {
     
    final directDownloadUrl =
        'https://drive.google.com/uc?export=download&id=1sCmQidx66zTAom_QsqBj4JpEURjE75ZY';
    final response = await http.get(
      Uri.parse(directDownloadUrl),
    );

    if (response.statusCode == 200) {
      final appDocDir = Directory('storage/emulated/0/Video');
      if (await appDocDir.exists()) {
         
      } else {
        appDocDir.create();
      }
      // print(appD)
      final String encryptedVideoFileName =
          'newNAme.mp4'; // Change to your desired file name
      File encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
       
      await encryptedVideo.writeAsBytes(response.bodyBytes);
       
       
      //  
//       if (!encryptedVideo.existsSync()) {
//          
//         return;
//       }

//       File outFile = File('${appDocDir.path}/newname.mp4');
//       bool outFileExists = await outFile.exists();

//       if (!outFileExists) {
//         await outFile.create();
//       }

      try {
        // final write = await encryptedVideo.writeAsBytes(response.bodyBytes);
        final videoFileContents = await encryptedVideo.readAsBytes();
         
        // final key = encrypt.Key.fromUtf8('my 32 length key................');
        final key = encrypt.Key.fromUtf8('00000000000000000000000000000000');

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
      } catch (e) {
         
      }
    } // this bracts for if status code condition
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("testS"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: downloadAndSavePdf(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error downloading video: ${snapshot.error}");
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      final fileInfo =
                          await videoCacheManager.getFileFromCache('yes');
                      if (fileInfo != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoScreen(videoFile: fileInfo.file),
                          ),
                        );
                      }
                    },
                    child: Text("Play Video"),
                  );
                }
              }),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              // final appDocDir = Directory('storage/emulated/0/Video');
              final appDocDir = await getApplicationSupportDirectory();

              final String encryptedVideoFileName = 'newNAme.mp4';
              File encryptedVideo =
                  File('${appDocDir.path}/$encryptedVideoFileName');

              encryptedVideo.deleteSync();

              // final fileInfo = await videoCacheManager.getFileFromCache('yes');
              // if (fileInfo != null) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => VideoScreen(videoFile: fileInfo.file),
              //     ),
              //   );
              // }
            },
            child: Text("Play Video"),
          ),
//           CircularProgressIndicator(
//   value: currentDay / maxDay,
// ),
// Text("${maxDay - currentDay}d"),
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

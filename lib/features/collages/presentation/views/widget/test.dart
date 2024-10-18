// import 'dart:convert';
// import 'dart:io';

// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   Future<void> requestPermissionsStorage() async {
//     final storageStatus = await Permission.storage.request();

//     if (storageStatus.isDenied) {
//       // You have the necessary permissions.
//       await requestPermissionsStorage();
//     }
//   }

//   Future<void> downloadEncryptedFile({
//     required String fileUrl,
//     required String fileName,
//   }) async {
//     await requestPermissionsStorage();
//     final appDocDir = Directory('storage/emulated/0/Video');
//     if (await appDocDir.exists()) {
//        
//     } else {
//       appDocDir.create();
//     }
//     // Change to your desired file name
//     final encryptedVideo = File('${appDocDir.path}/$fileName');
//     final response = await http.get(Uri.parse(fileUrl));
//     await encryptedVideo.writeAsBytes(response.bodyBytes);
//   }

//   Future<void> decryptFile(File file, String fileName, String type) async {
//     final videoFileContents = file.readAsBytesSync();
//     final key = encrypt.Key.fromUtf8('my 32 length key................');
//     final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: null));

//     final encryptedFile = encrypt.Encrypted(videoFileContents);
//     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

//     final decryptedBytes = latin1.encode(decrypted);
//     final cacheManager = DefaultCacheManager();
//     await cacheManager.putFile(
//       fileName, // You can use the URL as the key
//       decryptedBytes,
//       fileExtension: type,
//     );
//   }

//   Future<void> downloadAndSavePdf() async {
//     final directDownloadUrl =
//         'https://drive.google.com/uc?export=download&id=1Csq6Svk20fNrDgINNXie2IDYJYDOkhjp';
//     final response = await http.get(Uri.parse(directDownloadUrl));

//     if (response.statusCode == 200) {
//       final appDocDir = Directory('storage/emulated/0/Video');
//       if (await appDocDir.exists()) {
//          
//       } else {
//         appDocDir.create();
//       }
//       final encryptedVideoFileName =
//           'encryptedvideo.aes'; // Change to your desired file name
//       final encryptedVideo = File('${appDocDir.path}/$encryptedVideoFileName');
//       await encryptedVideo.writeAsBytes(response.bodyBytes);
//       //!.....................................................................................................

//       // File outFile = File('${appDocDir.path}/videoDecrpted.mp4');
//       // bool outFileExists = await outFile.exists();

//       // if (!outFileExists) {
//       //   await outFile.create();
//       // }

//       final videoFileContents = encryptedVideo.readAsBytesSync();

//       final key = encrypt.Key.fromUtf8('my 32 length key................');
//       final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
//       final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: null));

//       final encryptedFile = encrypt.Encrypted(videoFileContents);
//       final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

//       final decryptedBytes = latin1.encode(decrypted);
//       //!

//       // await outFile.writeAsBytes(decryptedBytes);
//       //  
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Center(
//               child: ElevatedButton(
//                   onPressed: () async {
//                     var picked = await FilePicker.platform.pickFiles();
//                     if (picked != null) {
//                       Directory appDocDirectory =
//                           await getApplicationSupportDirectory();

//                       File file = File(picked.files.single.path.toString());
//                       File inFile = file;
//                       File outFile = File("${appDocDirectory.path}/video.file");
//                       bool outFileExists = await outFile.exists();
//                       outFile.create();
//                       final videoFileContents =
//                           await inFile.readAsStringSync(encoding: latin1);

//                       final key = encrypt.Key.fromUtf8(
//                           'my 32 length key................');
//                       final iv = encrypt.IV.fromLength(16);

//                       final encrypter = encrypt.Encrypter(encrypt.AES(key));

//                       final encrypted =
//                           encrypter.encrypt(videoFileContents, iv: iv);
//                       await outFile.writeAsBytes(encrypted.bytes);
//                        
//                        
//                        
//                     }
//                   },
//                   child: Text("Upload this file")),
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   await downloadAndSavePdf();
//                 },
//                 child: Text(
//                   "downlad",
//                   style: TextStyle(color: Colors.red),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }

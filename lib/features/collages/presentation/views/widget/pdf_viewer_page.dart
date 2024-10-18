import 'dart:io';

import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../../../constants.dart';
import '../../../../../core/cache/cashe_helper.dart';
import '../../../../../core/utils/pdf_water_mark.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.url,
    this.pdfFIle,
    // required this.pdfFile,
  });
  // final File pdfFile;
  final String url;
  final File? pdfFIle;
  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage>
    with WidgetsBindingObserver {
  var pages;

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

  // Future<String> createFileOfPdfUrl(String pdfUrl) async {
  //   // Completer<File> completer = Completer();
  //   //
  //   String urlBefore = Encryption.decrypt(widget.pdfUrl);
  //   String url = convertDriveLink(urlBefore);
  //   //  String url =
  //   // '${Constants.kDefaultDomain}$pdfUrl?HB=${CasheHelper.getData(key: Constants.kToken)}';
  //   try {
  //     // collegeCubit.emit(LoadingGetPdfState());
  //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
  //     // final url = "https://pdfkit.org/docs/guide.pdf";
  //     // final url = "http://www.pdf995.com/samples/pdf.pdf";
  //     // final filename = url.substring(url.lastIndexOf("/") + 1);
  //     // var request = await HttpClient().getUrl(Uri.parse(url));
  //     // var response = await request.close();
  //     // var bytes = await consolidateHttpClientResponseBytes(response);
  //     var response = await http.get(Uri.parse(url));
  //     // var dir = await getApplicationDocumentsDirectory();
  //     var dir = await getTemporaryDirectory();
  //
  //     //
  //     File file = File("${dir.path}/data.pdf");
  //     await file.writeAsBytes(response.bodyBytes, flush: true);
  //
  //     // collegeCubit.emit(LoadingGetPdfState());
  //
  //     return file.path;
  //   } catch (e) {
  //     return 'error';
  //     // throw Exception('Error parsing asset file!');
  //   }
  // }

  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    if (widget.pdfFIle == null) {
      loadpdf();
    } else {
      filePath = widget.pdfFIle!.path;
    }
    WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   _isInForeground = state == AppLifecycleState.resumed;
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //
  //       widget.collegeCubit.cacheManager.emptyCache();
  //       break;
  //     case AppLifecycleState.inactive:
  //
  //       break;
  //     case AppLifecycleState.paused:
  //       widget.collegeCubit.cacheManager.emptyCache();
  //
  //       break;
  //     case AppLifecycleState.detached:
  //
  //       break;
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int loading = 0;
  String filePath = '';
  Future<String?>? loadpdf() async {
    String token = CasheHelper.getData(key: Constants.kToken);

    WidgetsFlutterBinding.ensureInitialized();
    if (mounted) {
      setState(() {
        loading = 1;
      });
    }

    // var second_link;
    // var first_link=Modify.pdf;
    // "https://drive.google.com/file/d/1uq3cweZu0weCn3E_uRyamjikYp8w7WYv/view?usp=drivesdk";
    // if(first_link.contains("=drivesdk"))
    // { second_link=first_link.replaceRange(first_link.indexOf("=drivesdk"), first_link.length, "=sharing");
    // }else{second_link=first_link;}
    // var final_link = convertDriveLink(second_link);
    try {
      var response = await http.get(
          // Uri.parse("${Constants.kBaseDownloadUrlPdf}${widget.url}"),
          Uri.parse('${Constants.kDefaultDomain}${widget.url}'),
          headers: {'Authorization': 'Bearer $token'});
      var dir = await getTemporaryDirectory();
      File file = File("${dir.path}/data.pdf");
      /*
      final waterMark = await CasheHelper.getData(key: Constants.kUserId);
      final userName = await CasheHelper.getData(key: Constants.kUserName);
      final userPhone = await CasheHelper.getData(key: Constants.kUserPhone);
      final finalBytes = await PDfMark.addNameAndWatermarkToAllPages(
        listOfBytes: response.bodyBytes,
        watermark: waterMark.toString(), //?? "al-amin",
        userName: userName.toString(), //?? "al-amin",
        userPhone: userPhone.toString(), // ?? "al-amin",
      );
      */

      await file.writeAsBytes(response.bodyBytes, flush: true);
      setState(() {
        loading = 0;
        filePath = file.path;
      });
      return file.path;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // CollegeCubit collegeCubit = CollegeCubit.get(context);

    // Future<void> decryptFile({
    //   required File file,
    //   required String fileName,
    //   required String type,
    // }) async {
    //   try {
    //     final videoFileContents = file.readAsBytesSync();
    //     final key = encrypt.Key.fromUtf8('my 32 length key................');
    //     final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
    //     final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: null));
    //     final encryptedFile = encrypt.Encrypted(videoFileContents);
    //     final decrypted = encrypter.decrypt(encryptedFile, iv: iv);
    //     final decryptedBytes = latin1.encode(decrypted);
    //     await collegeCubit.cacheManager.putFile(
    //       fileName, // You can use the URL as the key
    //       decryptedBytes,
    //       fileExtension: type,
    //     );
    //   } catch (e) {}
    // }

    // Future<String?> returnFile() async {
    //   return widget.pdfFIle!.path;
    // }

    // Future<String> returnUrl() async {
    //   return '${Constants.kBaseDownloadUrlPdf}${widget.url}';
    // }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // widget.collegeCubit.cacheManager.emptyCache();

            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body:
          // FutureBuilder(
          //   future: (widget.pdfFIle == null) ? ,
          //   builder: (context, snapshot) {
          //     // if (snapshot.connectionState == ConnectionState.waiting) {
          //     //   return CustomLoadingIndicator(
          //     //     color: AppColor.kPrimaryColor,
          //     //   );
          //     // } else
          //     if (snapshot.hasError) {
          //       return CustomErrorWidget(
          //         errMessage: snapshot.error.toString(),
          //         textStyle: Styles.textStyle15PriCol,
          //         iconColor: AppColor.kPrimaryColor,
          //       );
          //     } else if (snapshot.hasData) {
          //       return

          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (loading == 0)
              ? Expanded(
                  child: Visibility(
                    visible: loading == 0,
                    child: PDFView(
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages!;
                        });
                      },
                      defaultPage: 0,
                      filePath: filePath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: true,
                      onError: (error) {},
                      onPageError: (page, error) {},
                    ),
                  ),
                )
              : Center(
                  child: Visibility(
                    visible: loading == 1,
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),

      // } else {
      //   return const CircularProgressIndicator();
      // }
      // },
      // ),

      // SfPdfViewer.file(
      //   snapshot.data!.file,
      //   onDocumentLoadFailed: (details) {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         title: Text(details.error),
      //       ),
      //     );
      //   },
      //   canShowPageLoadingIndicator: false,

      //   // '${Constants.kDefaultDomain}$pdfUrl?HB=${CasheHelper.getData(key: Constants.kToken)}',
      //   // onTextSelectionChanged: false,
      //   enableTextSelection: false,
      // );
      //!
      // PDFView(
      //   onRender: (_pages) {
      //     setState(() {
      //       pages = _pages!;
      //     });
      //   },
      //   defaultPage: 0,
      //   filePath: snapshot.data,
      //   enableSwipe: true,
      //   swipeHorizontal: false,
      //   autoSpacing: true,
      //   pageFling: true,
      //   onError: (error) {
      //
      //   },
      //   onPageError: (page, error) {
      //
      //   },
      // );
      // } else {
      //   return Center(child: CircularProgressIndicator());
      // }

      // SfPdfViewer.network(
      //   onDocumentLoadFailed: (details) {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         title: Text(details.error),
      //       ),
      //     );
      //   },
      //   canShowPageLoadingIndicator: false,
      //   '${Constants.kDefaultDomain}$pdfUrl?HB=${CasheHelper.getData(key: Constants.kToken)}',
      //   // onTextSelectionChanged: false,
      //   enableTextSelection: false,
      // ),
    );
  }
}

/*
class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.url,
    this.pdfFIle,
  });
  final String url;
  final File? pdfFIle;
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool _isLoading = true;
  // final _storage = const FlutterSecureStorage();
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    // loadDocument();
    if (widget.pdfFIle == null) {
      changePDF(2);
    } else {
      changePDF(1);
    }
  }

  loadDocument() async {
    // document = await PDFDocument.fromAsset('assets/sample.pdf');

    setState(() => _isLoading = false);
  }

  changePDF(value) async {
    setState(() => _isLoading = true);
    if (value == 1) {
      document = await PDFDocument.fromFile(widget.pdfFIle!);
    } else if (value == 2) {
      String token = await CasheHelper.getData(key: Constants.kToken);
      // dio.options.headers["Authorization"] = "Bearer $token";
      document = await PDFDocument.fromURL(
        '${Constants.kBaseDownloadUrlPdf}${widget.url}',
        headers: {"Authorization": "Bearer $token"},

        /* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), */
      );

       
      //     /data/user/0/com.example.alaminedu/cache/libCachedImageData/d83da870-6f8f-11ee-b432-d3f971b6d141.pdf
      // setState(() => _isLoading = false);
    }
    // else {
    //   document = await PDFDocument.fromAsset('assets/sample.pdf');
    // }
    setState(() => _isLoading = false);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const Drawer(
      //   child: Column(
      //     children: <Widget>[
      //       SizedBox(height: 36),
      //       // ListTile(
      //       //   title: Text('Load from Assets'),
      //       //   onTap: () {
      //       //     changePDF(1);
      //       //   },
      //       // ),
      //       // ListTile(
      //       //   title: Text('Load from URL'),
      //       //   onTap: () {
      //       //     changePDF(2);
      //       //   },
      //       // ),
      //       // ListTile(
      //       //   title: Text('Restore default'),
      //       //   onTap: () {
      //       //     changePDF(3);
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),

      appBar: AppBar(
        title: const Text(
          'FlutterPluginPDFViewer',
          style: Styles.textStyle18White,
        ),
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                zoomSteps: 1,
                scrollDirection: Axis.vertical,
                //uncomment below line to preload all pages
                // lazyLoad: false,
                // uncomment below line to scroll vertically
                // scrollDirection: Axis.vertical,

                //uncomment below code to replace bottom navigation with your own
                /* navigationBuilder:
                          (context, page, totalPages, jumpToPage, animateToPage) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () {
                                jumpToPage()(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        );
                      }, */
              ),
      ),
    );
  }
}
*/

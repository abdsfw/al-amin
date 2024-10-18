import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';

class PDfMark {
  /*
  static Future<List<int>?> addNameAndWatermarkToAllPages(
      {List<int>? listOfBytes,
      required String watermark,
      required String userName,
      required String userPhone}) async {
    PdfDocument document = PdfDocument(inputBytes: listOfBytes);

    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 40);
    PdfFont nameFont = PdfStandardFont(PdfFontFamily.helvetica, 80);
    PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 80);

    for (var i = 0; i < document.pages.count; i++) {
      PdfPage page = document.pages[i];
      Size pageSize = page.getClientSize();

      //! Watermark
      PdfGraphics watermarkGraphics = page.graphics;
      PdfFont watermarkFont = PdfStandardFont(PdfFontFamily.helvetica, 300);
      Size watermarkSize = watermarkFont.measureString('Confidential');
      double watermarkX = pageSize.width / 2;
      double watermarkY = pageSize.height / 2;

      watermarkGraphics.save();
      watermarkGraphics.translateTransform(watermarkX, watermarkY);
      watermarkGraphics.setTransparency(0.25);
      watermarkGraphics.rotateTransform(-40);
      watermarkGraphics.drawString(watermark, watermarkFont,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
              -watermarkSize.width / 2,
              -watermarkSize.height / 2,
              watermarkSize.width,
              watermarkSize.height));
      watermarkGraphics.restore();

      //! Your Name
      PdfGraphics nameGraphics = page.graphics;
      Size nameSize = font.measureString(userName); // Replace with your name
      double nameX = 20; // Adjust X position to move the name towards the left
      double nameY = 30;

      nameGraphics.drawString(userName, nameFont,
          pen: PdfPen(PdfColor(0, 255, 0)),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(nameX, nameY - nameSize.height / 2,
              nameSize.width, nameSize.height));
//!phone number
      PdfGraphics contentGraphics = page.graphics;
      Size contentSize =
          contentFont.measureString(userPhone); // Replace with your content
      double contentX = 20; // Adjust X position as needed
      double contentY = pageSize.height -
          contentSize.height -
          10; // Set a margin from the bottom

      contentGraphics.drawString(userPhone, contentFont,
          pen: PdfPen(PdfColor(100, 255, 50)),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(contentX, contentY - contentSize.height / 2,
              contentSize.width, contentSize.height));
    }

    List<int> finalBytes = await document.save();

    document.dispose();
    return finalBytes;
    // saveAndLaunchFile(bytes, 'output.pdf');
  }
  */

  // static Future<List<int>> _readDocumentData(String name) async {
  //   final ByteData data = await rootBundle.load('assets/pdf/$name');
  //   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // }

  // static Future<void> saveAndLaunchFile(
  //     List<int> bytes, String fileName) async {
  //   //Get external storage directory
  //   Directory directory = await getApplicationSupportDirectory();
  //   //Get directory path
  //   String path = directory.path;
  //   //Create an empty file to write PDF data
  //   File file = File('$path/$fileName');
  //   //Write PDF data
  //   await file.writeAsBytes(bytes, flush: true);
  //   //Open the PDF document in mobile
  //   OpenFile.open('$path/$fileName');
  // }
}

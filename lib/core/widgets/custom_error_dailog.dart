import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../utils/color_app.dart';

class ErrorDialog {
  static void show(BuildContext context, String error) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      body: Center(
        child: Text(
          error,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      title: 'Registration Failed',
      desc: 'An error occurred during registration.',
      btnOkOnPress: () {},
      btnOkColor: AppColor.kPrimaryColor,
    ).show();
  }
}

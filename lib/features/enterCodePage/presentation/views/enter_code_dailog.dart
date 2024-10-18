import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/features/login/text_field_card.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'data/add_code_api.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;

  CustomDialogBox({
    required this.title,
    required this.descriptions,
    required this.text,
    required UniqueKey key,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ConstantsD.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: ConstantsD.padding,
              top: ConstantsD.avatarRadius + ConstantsD.padding,
              right: ConstantsD.padding,
              bottom: ConstantsD.padding),
          margin: const EdgeInsets.only(top: ConstantsD.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(ConstantsD.padding),
              boxShadow: [
                const BoxShadow(
                    color: AppColor.kPrimaryColor,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "enter code please",
                style: Styles.textStyle20PriCol,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _codeController,
                labelStyle: Styles.textStyle12,
                labelText: "Your code",
                prefixIcon: Icons.code_sharp,
                readOnly: false,
              ),
              const SizedBox(
                height: 22,
              ),
              isLoading
                  ? const Center(
                      child:
                          CustomLoadingIndicator(color: AppColor.kPrimaryColor),
                    )
                  : Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              onPressed: isLoading
                                  ? null // Disable the button while loading
                                  : () async {
                                      if (_codeController.text.isEmpty) {
                                        await AwesomeDialog(
                                                context: context,
                                                animType: AnimType.scale,
                                                dialogType: DialogType.error,
                                                body: const Center(
                                                  child: Text(
                                                    "please insert code",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                                title: 'This is Ignored',
                                                desc: 'This is also Ignored',
                                                btnOkOnPress: () {},
                                                btnOkColor:
                                                    AppColor.kPrimaryColor)
                                            .show();
                                        return;
                                      }
                                      if (mounted) {
                                        setState(() {
                                          isLoading = true; // Set loading state
                                        });
                                      }

                                      final response =
                                          await AddCodeApi.addCourseCode(
                                              _codeController.text);
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          const CustomSnackBar.success(
                                            message:
                                                "code added successfully. Have a nice day",
                                          ),
                                        );
                                      } else {
                                        // print(
                                        //     'response paras: ${response.reasonPhrase}');
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          const CustomSnackBar.error(
                                            message:
                                                "Something went wrong. or the code is used",
                                          ),
                                        );
                                      }
                                      if (mounted) {
                                        setState(() {
                                          isLoading =
                                              false; // Reset loading state
                                        });
                                      }
                                      Navigator.of(context).pop();
                                    },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.kPrimaryColor),
                              child: Text(
                                "Ok",
                                style: Styles.textStyle14
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.kPrimaryColor),
                              child: Text(
                                "Cansel",
                                style: Styles.textStyle14
                                    .copyWith(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        Positioned(
          left: ConstantsD.padding,
          right: ConstantsD.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: ConstantsD.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(ConstantsD.avatarRadius)),
                child: Image.asset(
                  Constants.kBinaryCode,
                )),
          ),
        ),
      ],
    );
  }
}

class ConstantsD {
  ConstantsD._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

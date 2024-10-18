import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/pdf_and_video_library.dart';
import 'package:alaminedu/features/enterCodePage/presentation/views/enter_code_dailog.dart';
import 'package:alaminedu/features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'package:alaminedu/features/inbox/presentation/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/utils/styles.dart';
import '../../../../StudentDetailsPage/presentation/views/student_details_page.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);

    FIleCubit fIleCubit = FIleCubit.get(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StudentDetailsPage(),
                  ),
                );
              },
              splashColor: AppColor.kPinkCustomColor,
              child: const CircleAvatar(
                backgroundColor: AppColor.kPrimaryColor,
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 75,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            children: [
              // ------------- enter code -------------
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: BlocConsumer<FIleCubit, FIleState>(
                    listener: (context, state) {
                      if (state is SuccessPostCodeState) {
                        Navigator.of(context).pop();
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: "code added successfully. Have a nice day",
                          ),
                        );
                      } else if (state is FailurePostCodeState) {
                        Navigator.of(context).pop();
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                "Something went wrong. or the code is used",
                          ),
                        );
                      } else if (state is LoadingPostCodeState) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const AlertDialog(
                            scrollable: true,
                            content: CustomLoadingIndicator(
                              color: AppColor.kPrimaryColor,
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Card(
                        color: Colors.white70, // AppColor.mainHomeButtonColor,
                        child: ListTile(
                          // splashColor: Colors.amber,
                          // hoverColor: Colors.black,
                          title: const Image(
                            image: AssetImage(
                              Constants.kBinaryCode,
                            ),
                            fit: BoxFit.cover,
                          ),
                          subtitle: Text(
                            'Enter Code',
                            // maxLines: 1,
                            textAlign: TextAlign.center,
                            style: Styles.textStyle20Black.copyWith(
                                fontSize: 12,
                                fontFamily: null,
                                fontWeight: FontWeight.bold
                                // color: AppColor.kTextColor,
                                ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                scrollable: true,
                                content: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomDialogBox(
                                              key:
                                                  UniqueKey(), // Provide a unique key here
                                              title: "asa",
                                              descriptions: "asas",
                                              text: "nnnnn",
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'enter code',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FlutterBarcodeScanner.scanBarcode(
                                          '#ff6666',
                                          'cancel',
                                          true,
                                          ScanMode.QR,
                                        ).then((value) {
                                          if (value == '-1') {
                                            // saleCubit.getStudentFromDatabase(
                                            // saleCubit.database2, '1000045');
                                            //
                                            // saleCubit.fetchOneStudent('1000045');
                                          } else {
                                            Navigator.of(context).pop();
                                            fIleCubit.postCode(data: {
                                              'code': value.toString(),
                                            });
                                          }
                                        }).catchError((Error) {});
                                      },
                                      child: const Text(
                                        'QR code',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              // --------------------------------------

              // ------------- Library ----------------
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Card(
                    color: Colors.white70, // AppColor.mainHomeButtonColor,
                    child: ListTile(
                      // splashColor: Colors.amber,
                      // hoverColor: Colors.black,
                      title: const Image(
                        image: AssetImage(
                          Constants.kLibrary,
                        ),
                        fit: BoxFit.cover,
                      ),
                      subtitle: Text(
                        'Library',
                        textAlign: TextAlign.center,
                        style: Styles.textStyle20Black.copyWith(
                            fontSize: 12,
                            fontFamily: null,
                            fontWeight: FontWeight.bold
                            // color: AppColor.kTextColor,
                            ),
                      ),
                      onTap: () async {
                        collegeCubit.getDataFromFileTable();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PdfAndVideoLibrary(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // --------------------------------------

              // -------------- inbox -----------------
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Card(
                    color: Colors.white70, // AppColor.mainHomeButtonColor,
                    child: ListTile(
                      // splashColor: Colors.amber,
                      // hoverColor: Colors.black,
                      title: const Image(
                        image: AssetImage(
                          Constants.kEmail,
                        ),
                        fit: BoxFit.cover,
                      ),
                      subtitle: Text(
                        'Inbox',
                        textAlign: TextAlign.center,
                        style: Styles.textStyle20Black.copyWith(
                            fontSize: 12,
                            fontFamily: null,
                            fontWeight: FontWeight.bold
                            // color: AppColor.kTextColor,
                            ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ChatScreens(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // --------------------------------------
            ],
          )
          // const Text(
          //   'student name',
          //   style: Styles.textStyle20Black,
          // ),
        ],
      ),
    );
  }
}

import 'package:alaminedu/features/JCI/presentation/manager/jci_cubit/jci_cubit.dart';
import 'package:alaminedu/features/JCI/presentation/view/jci_home_page.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/lessons_home_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/video_test.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/vimeo_video_player_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/vimeo_video_player_page2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../collages/presentation/views/college_home_page.dart';

class HomeGridView extends StatelessWidget {
  const HomeGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);

    return Expanded(
      flex: 2,
      child: GridView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          /*
          BlocConsumer<FIleCubit, FIleState>(
            listener: (context, state) {
              if (state is SuccessPostCodeState) {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: "code added successfully. Have a nice day",
                  ),
                );
              } else if (state is FailurePostCodeState) {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: "Something went wrong. or the code is used",
                  ),
                );
              }
            },
            builder: (context, state) {
              return const SizedBox();
            },
          ),
          */
          // ------------- college ----------------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              title: const Image(
                image: AssetImage(
                  Constants.kCollege,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'College',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  // color: AppColor.kTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                collegeCubit.fetchAllColleges();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CollegeHomePage(),
                  ),
                );
              },
            ),
          ),
          // --------------------------------------
          //! enter code button is commended
          /*
          // ------------- enter code -------------
          BlocConsumer<FIleCubit, FIleState>(
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
                    message: "Something went wrong. or the code is used",
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
                color: Colors.white70,
                child: ListTile(
                  // splashColor: Colors.amber,
                  // hoverColor: Colors.black,
                  title: const Image(
                    image: AssetImage(
                      Constants.kBinaryCode,
                    ),
                    fit: BoxFit.cover,
                  ),
                  subtitle: const Text(
                    'enter code',
                    textAlign: TextAlign.center,
                    style: Styles.textStyle20Black,
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
                                }).catchError((Error) {
                                   
                                });
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
          // --------------------------------------
         */

          //! inbox button is commended
          /*
          // -------------- inbox -----------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kEmail,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'inbox',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
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
          // --------------------------------------
          */
          //! library button is commended
          /*
          // ------------- Library ----------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kLibrary,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'Library',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
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
          // --------------------------------------
         */
          // ------------ External Course ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.logoCoursesWithoutBg,
                  // Constants
                  //     .logoCourses, // "assets/image/logos.png", //"assets/image/external_course.png", //Constants.kExternalCourse,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'Courses',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the external courses type = 1
                /*
                  ? because `LessonsHomePage` depends on future builder so
                  ? calling api does inside the page , the api called `fetchExternalCoursesAndNewCourse`
                  ? this api to fetch `external course` , `chess` , `school language`and `icdl`
                  ? but for `external course` there is special url and others
                  ? there is another one
                */
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LessonsHomePage(
                      yearIndex: null,
                      yearID: null,
                      nameIfNotFromYear: "External Courses",
                      // isExternalCourse: true,
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------------------------------------

          // ------------ Jci ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.jciImage,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'JCI',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the jci type = 2
                BlocProvider.of<JciCubit>(context)
                    .getAllJCICategory(typeQuery: 2);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const JCIHomePage(
                      title: "JCI",
                    ),
                  ),
                );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const PlayVideoFromVimeoPrivateVideo(
                //       title: "abd ",
                //       videoID: "940321503",
                //     ),
                //   ),
                // );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => VideoPlayerScreenTEst3(
                //       name: "",
                //       url: "",
                //       videoFile: null,
                //     ),
                //   ),
                // );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const VimeoVideoPlayerPage(
                //       title: "abd",
                //       videoUrl: "https://vimeo.com/940321503",
                //     ),
                //   ),
                // );
              },
            ),
          ),
          // ----------------------------------------

          // ------------ technology ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.technologyIcon,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'Technology',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the technology type = 4
                BlocProvider.of<JciCubit>(context)
                    .getAllJCICategory(typeQuery: 4);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const JCIHomePage(
                      title: "Technology",
                    ),
                  ),
                );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const PlayVideoFromVimeoPrivateVideo(
                //       title: "abd ",
                //       videoID: "940321503",
                //     ),
                //   ),
                // );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => VideoPlayerScreenTEst3(
                //       name: "",
                //       url: "",
                //       videoFile: null,
                //     ),
                //   ),
                // );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const VimeoVideoPlayerPage(
                //       title: "abd",
                //       videoUrl: "https://vimeo.com/940321503",
                //     ),
                //   ),
                // );
              },
            ),
          ),
          // ----------------------------------------

          // ------------ chess ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.chessIcon,
                  // Constants
                  //     .logoCourses, // "assets/image/logos.png", //"assets/image/external_course.png", //Constants.kExternalCourse,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'Chess',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the chess type = 3

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LessonsHomePage(
                      yearIndex: null,
                      yearID: null,
                      nameIfNotFromYear: "Chess",
                      numberOfType: 3,
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------------------------------------

          // ------------ school language ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.englishForSchoolIcon,
                  // Constants
                  //     .logoCourses, // "assets/image/logos.png", //"assets/image/external_course.png", //Constants.kExternalCourse,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'School Language',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the School Language type = 5
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LessonsHomePage(
                      yearIndex: null,
                      yearID: null,
                      nameIfNotFromYear: "School Language",
                      numberOfType: 5,
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------------------------------------

          // ------------ icdl ---------
          Card(
            color: Colors.white70, // AppColor.mainHomeButtonColor,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.icdlIcon,
                  // Constants
                  //     .logoCourses, // "assets/image/logos.png", //"assets/image/external_course.png", //Constants.kExternalCourse,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: Text(
                'icdl',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black.copyWith(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  // color: AppColor.kTextColor,
                ),
              ),
              onTap: () async {
                //? note : from backend the icdl type = 6
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LessonsHomePage(
                      yearIndex: null,
                      yearID: null,
                      nameIfNotFromYear: "icdl",
                      numberOfType: 6,
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------------------------------------
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/encrypt.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/pdf_viewer_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../core/widgets/custom_error_dailog.dart';

import '../../../data/models/all_quiz_model/all_quiz_model.dart';
// import 'package:websafe_svg/websafe_svg.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({
    super.key,
    required this.quizID,
    required this.courseID,
    // required this.levelID,
    // required this.levelName,
  });
  final int quizID;
  final int courseID;
  // final int levelID;
  // final String levelName;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pop();
        Navigator.of(context).pop();
        collegeCubit.allExam = AllQuizModel(
          questions: [],
        );
        collegeCubit.answerChosen = [];
        collegeCubit.currentQuestionIndex = 1;

        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              collegeCubit.allExam = AllQuizModel(
                questions: [],
              );
              collegeCubit.answerChosen = [];

              collegeCubit.currentQuestionIndex = 1;
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/image/bgC.png',
              ),
            ),
          ),
          child: BlocBuilder<CollegeCubit, CollegeState>(
            builder: (context, state) {
              if (state is LoadingFetchQuizState) {
                return const CustomLoadingIndicator();
              } else if (state is FailureFetchQuizState) {
                return CustomErrorWidget(errMessage: state.errMessage);
              } else {
                int allQuestion = 0;
                for (var question in collegeCubit.quiz.questions!) {
                  if (question.type == 'question') {
                    allQuestion++;
                  } else if (question.type == 'exercise') {
                    allQuestion += question.exerciseQuestions!.length;
                  }
                }
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding,
                          ),
                          child: BlocBuilder<CollegeCubit, CollegeState>(
                            builder: (context, state) {
                              return Text.rich(
                                TextSpan(
                                  text:
                                      'Question ${collegeCubit.currentQuestionIndex}',
                                  style: Styles.textStyle25grey,
                                  children: [
                                    TextSpan(
                                      // text: '/${allQuestion.toString()}',
                                      text:
                                          '/${collegeCubit.allExam.questions!.length}',
                                      style: Styles.textStyle14grey,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(
                          endIndent: 20,
                          indent: 20,
                        ),
                        // QuestionCard(),
                        Expanded(
                          child: PageView.builder(
                            // itemCount: allQuestion,
                            itemCount: collegeCubit.allExam.questions!.length,
                            onPageChanged: (value) {
                              collegeCubit.currentQuestionIndex = value + 1;
                              collegeCubit.emit(SuccessFetchQuizState());
                            },
                            itemBuilder: (context, index) {
                              return QuestionCard(
                                questionIndex: index,
                                courseID: courseID,
                                quizID: quizID,
                                // levelID: levelID,
                                // levelName: levelName,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionIndex,
    required this.quizID,
    required this.courseID,
    // required this.levelID,
    // required this.levelName,
  });
  final int questionIndex;
  final int quizID;
  final int courseID;
  // final int levelID;
  // final String levelName;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    // Future<String> createFileOfPdfUrl(String pdfUrl) async {
    //   // Completer<File> completer = Completer();
    //   //
    //   try {
    //     // collegeCubit.emit(LoadingGetPdfState());
    //     // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    //     // final url = "https://pdfkit.org/docs/guide.pdf";
    //     // final url = "http://www.pdf995.com/samples/pdf.pdf";
    //     // final filename = url.substring(url.lastIndexOf("/") + 1);
    //     // var request = await HttpClient().getUrl(Uri.parse(url));
    //     // var response = await request.close();
    //     // var bytes = await consolidateHttpClientResponseBytes(response);
    //     var response = await http.get(Uri.parse(pdfUrl));
    //     // var dir = await getApplicationDocumentsDirectory();
    //     var dir = await getTemporaryDirectory();
    //
    //     //
    //     File file = File("${dir.path}/data.pdf");
    //     await file.writeAsBytes(response.bodyBytes, flush: true);
    //     // collegeCubit.emit(LoadingGetPdfState());
    //     return file.path;
    //   } catch (e) {
    //     throw Exception('Error parsing asset file!');
    //   }
    // }

    //
    //
    String type = '';
    if (collegeCubit.allExam.questions![questionIndex].type == 'exercise') {
      type = 'exercise';
    } else if (collegeCubit.allExam.questions![questionIndex].type ==
        'question') {
      type = 'question';
    }
    bool pdfQuestion = true;
    if (type == 'question') {
      if (collegeCubit.allExam.questions![questionIndex].urlType == 'text') {
        pdfQuestion = false;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      padding: const EdgeInsets.all(
        Constants.defaultPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocConsumer<CollegeCubit, CollegeState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    if (state is FileIsExistStatePdf) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          backgroundColor: AppColor.kPrimaryColor,
                          title: Text(
                            'This file has already been uploaded',
                            style: Styles.textStyle18White,
                          ),
                        ),
                      );
                    } else if (state is AlertDecryptFile) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          backgroundColor: AppColor.kPrimaryColor,
                          content: Text(
                            'please wait for encryption process',
                            style: Styles.textStyle14White,
                            maxLines: 5,
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          type,
                          style: Styles.textStyle20PriCol,
                        ),
                      ),
                    );
                  },
                ),
                if (pdfQuestion)
                  Column(
                    children: [
                      ElevatedButton(
                        onLongPress: () async {
                          // final appDocDir =
                          //     Directory('storage/emulated/0/video');
                          final appDocDir =
                              await getApplicationSupportDirectory();

                          // collegeCubit
                          // .allExam.questions![questionIndex].
                          String fileName =
                              'pdf$type${collegeCubit.allExam.questions![questionIndex].id}';
                          final File file =
                              File('${appDocDir.path}/$fileName.zbr');
                          if (file.existsSync()) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColor.kPrimaryColor,
                                title: const Text(
                                  'do you want to delete this file?',
                                  style: Styles.textStyle18White,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      // final appDocDir =
                                      //     Directory('storage/emulated/0/video');
                                      final appDocDir =
                                          await getApplicationSupportDirectory();

                                      // collegeCubit
                                      // .allExam.questions![questionIndex].
                                      String fileName =
                                          'pdf$type${collegeCubit.allExam.questions![questionIndex].id}';
                                      final File file = File(
                                          '${appDocDir.path}/$fileName.zbr');
                                      if (file.existsSync()) {
                                        file.deleteSync();
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                            backgroundColor:
                                                AppColor.kPrimaryColor,
                                            title: Text(
                                              'Deleted successfully',
                                              style: Styles.textStyle18White,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text(
                                      'ok',
                                      style: Styles.textStyle15PriCol,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColor.kPrimaryColor,
                              title: const Text(
                                'select type of open pdf',
                                style: Styles.textStyle18White,
                              ),
                              content: const Text(
                                'Note: The offline mode will take time to open the file and will use the device\'s resources',
                                style: Styles.textStyle14White,
                              ),
                              actions: [
                                ElevatedButton(
                                  child: const Text('online'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PdfViewerPage(
                                          url: collegeCubit.allExam
                                              .questions![questionIndex].url!,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // final appDocDir =
                                    //     Directory('storage/emulated/0/video');
                                    final appDocDir =
                                        await getApplicationSupportDirectory();

                                    // collegeCubit
                                    // .allExam.questions![questionIndex].
                                    String fileName =
                                        'pdf$type${collegeCubit.allExam.questions![questionIndex].id}';
                                    final File file =
                                        File('${appDocDir.path}/$fileName.zbr');

                                    if (file.existsSync()) {
                                      collegeCubit.decryptFile(
                                        file: file,
                                        fileName: fileName,
                                        type: 'pdf',
                                      );
                                      //     .then((value) async {
                                      //   final fileInfo =
                                      //       await collegeCubit.cacheManager.getFileFromCache(
                                      //     fileName,
                                      //   );
                                      // });

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          // collegeCubit.emit(
                                          // LoadingDecryptFile());
                                          return AlertDialog(
                                            backgroundColor:
                                                AppColor.kPrimaryColor,
                                            title: const Text(
                                              'please wait',
                                              style: Styles.textStyle14White,
                                            ),
                                            content: BlocConsumer<CollegeCubit,
                                                CollegeState>(
                                              listener: (context, state) async {
                                                if (state
                                                    is SuccessDecryptFile) {
                                                  // print(
                                                  // '55555555555555555555555555555555555555000');

                                                  final fileInfo =
                                                      await collegeCubit
                                                          .cacheManager
                                                          .getFileFromCache(
                                                    'pdf$type${collegeCubit.allExam.questions![questionIndex].id}',
                                                  );
                                                  // if (fileInfo != null) {
                                                  Navigator.of(context).pop();
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PdfViewerPage(
                                                        url: collegeCubit
                                                            .allExam
                                                            .questions![
                                                                questionIndex]
                                                            .url!,
                                                        pdfFIle: fileInfo!.file,
                                                      ),
                                                    ),
                                                  );

                                                  // } else {
                                                  //
                                                  // }
                                                }
                                              },
                                              builder: (context, state) {
                                                if (state
                                                    is LoadingDecryptFile) {
                                                  return CustomLoadingIndicator();
                                                } else if (state
                                                    is FailureDecryptFile) {
                                                  return CustomErrorWidget(
                                                    errMessage:
                                                        state.errMessage,
                                                  );
                                                }
                                                return SizedBox();
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    } else {}
                                  },
                                  child: const Text(
                                    'offline',
                                  ),
                                ),
                              ],
                            ),
                          );
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => PdfViewerPage(
                          //       url: collegeCubit
                          //           .allExam.questions![questionIndex].url!,
                          //     ),
                          //   ),
                          // );
                          /*
                          final appDocDir =
                              Directory('storage/emulated/0/video');
                          // collegeCubit
                          // .allExam.questions![questionIndex].
                          String fileName =
                              'pdf$type${collegeCubit.allExam.questions![questionIndex].id}';
                          final File file =
                              File('${appDocDir.path}/$fileName.zbr');
                           

                          if (file.existsSync()) {
                            collegeCubit.decryptFile(
                              file: file,
                              fileName: fileName,
                              type: 'pdf',
                            );
                            //     .then((value) async {
                            //   final fileInfo =
                            //       await collegeCubit.cacheManager.getFileFromCache(
                            //     fileName,
                            //   );
                            // });

                            showDialog(
                              context: context,
                              builder: (context) {
                                // collegeCubit.emit(
                                // LoadingDecryptFile());
                                return AlertDialog(
                                  backgroundColor: AppColor.kPrimaryColor,
                                  title: Text(
                                    'please wait',
                                    style: Styles.textStyle14White,
                                  ),
                                  content:
                                      BlocConsumer<CollegeCubit, CollegeState>(
                                    listener: (context, state) async {
                                      if (state is SuccessDecryptFile) {
                                        // print(
                                        // '55555555555555555555555555555555555555000');

                                        // final fileInfo = await collegeCubit
                                        //     .cacheManager
                                        //     .getFileFromCache(
                                        //   'pdf${collegeCubit.level.pdfs![index].id}',
                                        // );
                                        // if (fileInfo != null) {
                                        Navigator.of(context).pop();
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => PdfViewerPage(
                                        //       collegeCubit: collegeCubit,
                                        //       pdfName: fileName,
                                        //       pdfType: 'pdf',
                                        //     ),
                                        //   ),
                                        // );

                                        // } else {
                                        //    
                                        // }
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is LoadingDecryptFile) {
                                        return CustomLoadingIndicator();
                                      } else if (state is FailureDecryptFile) {
                                        return CustomErrorWidget(
                                          errMessage: state.errMessage,
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                );
                              },
                            );

                             
                          } else {
                             
                          }
                            */
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage(
                              'assets/image/pdf.png',
                            ),
                            height: 40,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: collegeCubit.pdfIsDownloadedQuz[questionIndex],
                        child: BlocConsumer<CollegeCubit, CollegeState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return CircularPercentIndicator(
                              // animation: true,
                              // animationDuration: 2000,
                              // lineHeight: 20,
                              // barRadius: const Radius.circular(10),
                              progressColor: Colors.white,
                              backgroundColor: AppColor.kPrimaryColor,
                              percent: (collegeCubit.maxPdfDownloadBytesQuz[
                                          questionIndex] ==
                                      0)
                                  ? 0
                                  : collegeCubit
                                          .pdfDownloadBytesQuz[questionIndex] /
                                      collegeCubit.maxPdfDownloadBytesQuz[
                                          questionIndex],
                              center: Text(
                                (collegeCubit.maxPdfDownloadBytesQuz[
                                            questionIndex] ==
                                        0)
                                    ? '0%'
                                    : '${((collegeCubit.pdfDownloadBytesQuz[questionIndex] / collegeCubit.maxPdfDownloadBytesQuz[questionIndex]) * 100).toStringAsFixed(0)}%',
                                style: Styles.textStyle12.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.withOpacity(0.7),
                                ),
                              ),
                              radius: 20,
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            !collegeCubit.pdfIsDownloadedQuz[questionIndex],
                        child: IconButton(
                          onPressed: () {
                            collegeCubit.downloadEncryptedFile(
                              courseID: collegeCubit.allExam.courseId!,
                              // levelID: levelID,
                              storageName:
                                  'pdf$type${collegeCubit.allExam.questions![questionIndex].id}.zbr',
                              isVideo: false,
                              fileID: collegeCubit
                                  .allExam.questions![questionIndex].id!,
                              type: 'pdf',
                              index: questionIndex,
                              isQes: true,
                              fileName: 'pdf-index $questionIndex-$type-',
                              fileUrl: collegeCubit
                                  .allExam.questions![questionIndex].url!,
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            QuestionPart(questionIndex: questionIndex),
            // Divider(),
            OptionContainer(questionIndex: questionIndex),
            if (collegeCubit.allExam.questions![questionIndex].type ==
                'exercise')
              const Text(
                'Please solve on an external paper and then answer the multiple choice questions.',
                textAlign: TextAlign.center,
                style: Styles.textStyle18grey,
              ),

            if ((questionIndex + 1) == collegeCubit.allExam.questions!.length)
              ElevatedButton(
                onPressed: () {
                  int markQuestion = 0;
                  for (int i = 0; i < collegeCubit.answerChosen.length; i++) {
                    if (collegeCubit.answerChosen[i] != -1) {
                      if (collegeCubit
                          .allExam
                          .questions![i]
                          .answers![collegeCubit.answerChosen[i] - 1]
                          .isCorrect!) {
                        markQuestion +=
                            collegeCubit.allExam.questions![i].mark!;
                      }
                    }
                    //
                  }
                  var mark = {"mark": markQuestion, "quiz_id": quizID};

                  collegeCubit.postMarkQuiz(mark: mark);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kPrimaryColor,
                ),
                child: BlocConsumer<CollegeCubit, CollegeState>(
                  listener: (context, state) {
                    if (state is FailureAddMarkState) {
                      ErrorDialog.show(
                        context,
                        state.errMessage,
                      );
                    } else if (state is SuccessAddMarkState) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            fullMark: collegeCubit.allExam.fullMark!,
                            examMark: state.examMark,
                            courseID: courseID,
                            successMark: collegeCubit.allExam.successMark!,
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingAddMarkState) {
                      return const SpinKitSpinningLines(
                        color: Colors.white,
                        size: 40,
                      );
                    } else {
                      return const Text(
                        'Send Solution',
                        style: Styles.textStyle18White,
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuestionPart extends StatelessWidget {
  const QuestionPart({
    super.key,
    required this.questionIndex,
  });
  final int questionIndex;
  @override
  Widget build(BuildContext context) {
    String text = '';
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    if (collegeCubit.allExam.questions![questionIndex].type == 'question') {
      text = (collegeCubit.allExam.questions![questionIndex].urlType == 'text')
          ? Encryption.decrypt(
              collegeCubit.allExam.questions![questionIndex].url ?? '')
          : '';
    } else if (collegeCubit.allExam.questions![questionIndex].type ==
        'exercise') {
      text = collegeCubit.allExam.questions![questionIndex].name!;
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: Styles.textStyle16.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Expanded(
        //   child: ListTile(
        //     onTap: () {},
        //     title: const Image(
        //       image: AssetImage(
        //         'assets/image/pdf.png',
        //       ),
        //       height: 60,
        //     ),
        //     subtitle: const Text(
        //       'lesson pdf',
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class OptionContainer extends StatelessWidget {
  const OptionContainer({
    super.key,
    required this.questionIndex,
  });
  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return Expanded(
      child: ListView.builder(
        itemCount:
            collegeCubit.allExam.questions![questionIndex].answers!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            collegeCubit.answerChosen[questionIndex] = index + 1;
            collegeCubit.emit(SuccessFetchQuizState());
          },
          child: BlocBuilder<CollegeCubit, CollegeState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(top: Constants.defaultPadding),
                padding: const EdgeInsets.all(Constants.defaultPadding),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        (collegeCubit.answerChosen[questionIndex] == index + 1)
                            ? AppColor.kPrimaryColor
                            : const Color(0xFFC1C1C1),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}. ${collegeCubit.allExam.questions![questionIndex].answers![index].name}',
                      style: (collegeCubit.answerChosen[questionIndex] ==
                              index + 1)
                          ? Styles.textStyle18grey.copyWith(
                              color: AppColor.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            )
                          : Styles.textStyle18grey,
                    ),
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: (collegeCubit.answerChosen[questionIndex] ==
                                index + 1)
                            ? AppColor.kPrimaryColor
                            : null,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: (collegeCubit.answerChosen[questionIndex] ==
                                  index + 1)
                              ? AppColor.kPrimaryColor
                              : const Color(0xFFC1C1C1),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/features/collages/data/models/level_model/level_model.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/pdf_viewer_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/color_app.dart';
import '../../../../../core/utils/styles.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({super.key, required this.levelID});
  final int levelID;

  @override
  Widget build(BuildContext context) {
    // final pdfCacheManager = DefaultCacheManager();
    CollegeCubit collegeCubit = CollegeCubit.get(context);

    return WillPopScope(
      onWillPop: () async {
        collegeCubit.isSelectMode = false;
        if (collegeCubit.isSelectMode) {
          collegeCubit.selectedList = collegeCubit.selectedListToReset;
        }
        // collegeCubit.emit(SuccessGetLevelState());
        collegeCubit.level = LevelModel();
        collegeCubit.selectedList = [];
        collegeCubit.selectedListToReset = [];
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<CollegeCubit, CollegeState>(
            builder: (context, state) {
              return Text(
                collegeCubit.level.name ?? '',
                style: Styles.textStyle18White,
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              collegeCubit.isSelectMode = false;
              if (collegeCubit.isSelectMode) {
                collegeCubit.selectedList = collegeCubit.selectedListToReset;
              }
              // collegeCubit.emit(SuccessGetLevelState());
              collegeCubit.level = LevelModel();

              collegeCubit.selectedList = [];
              collegeCubit.selectedListToReset = [];
            },
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            start: 10,
            end: 10,
          ),
          child: BlocBuilder<CollegeCubit, CollegeState>(
            builder: (context, state) {
              if (state is LoadingGetLevelState) {
                return const CustomLoadingIndicator(
                  color: AppColor.kPrimaryColor,
                );
              } else if (state is FailureGetLevelState) {
                return CustomErrorWidget(
                  errMessage: state.errMessage,
                  textStyle: Styles.textStyle20PriCol,
                  iconColor: Colors.black,
                );
              } else {
                // for()
                return const BodyOfLevelPage();
              }
            },
          ),
        ),
      ),
    );
  }
}

class BodyOfLevelPage extends StatelessWidget {
  const BodyOfLevelPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    // @pragma('vm:entry-point')
    // void ffff(int x) async {
    //   collegeCubit.decryptFile(
    //     file: File('d'),
    //     fileName: 'pdf${collegeCubit.level.pdfs![0].id}',
    //     type: 'pdf',
    //   );
    // }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: Constants.listViewDecoration,
      // height: 200,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  if (collegeCubit.videoIsDownloaded.length !=
                          collegeCubit.level.videos!.length ||
                      collegeCubit.videoDownloadBytes.length !=
                          collegeCubit.level.videos!.length ||
                      collegeCubit.maxVideoDownloadBytes.length !=
                          collegeCubit.level.videos!.length) {
                    collegeCubit.videoIsDownloaded = [];
                    collegeCubit.videoDownloadBytes = [];
                    collegeCubit.maxVideoDownloadBytes = [];
                    for (var element in collegeCubit.level.videos!) {
                      collegeCubit.videoIsDownloaded.add(false);
                      collegeCubit.videoDownloadBytes.add(0);
                      collegeCubit.maxVideoDownloadBytes.add(0);
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColor.kPrimaryColor,
                      title: const Text(
                        'Choose Video Resolution',
                        style: Styles.textStyle18White,
                      ),
                      content: SingleChildScrollView(
                          child: BlocConsumer<CollegeCubit, CollegeState>(
                        listener: (context, state) {
                          // TODO: implement listener
                          if (state is FileIsExistState) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                backgroundColor: AppColor.kPrimaryColor,
                                title: Text(
                                  'This file has already been downloaded',
                                  style: Styles.textStyle18White,
                                ),
                              ),
                            );
                          } else if (state is FailureDecryptFile) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColor.kPrimaryColor,
                                content: Text(
                                  state.errMessage,
                                  style: Styles.textStyle14White,
                                  maxLines: 5,
                                ),
                              ),
                            );
                          } else if (state is FailureDownloadFile) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColor.kPrimaryColor,
                                content: Text(
                                  state.errMessage,
                                  style: Styles.textStyle14White,
                                  maxLines: 5,
                                ),
                              ),
                            );
                          } else if (state is AlertDecryptFile) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                backgroundColor: AppColor.kPrimaryColor,
                                content: Text(
                                  'please wait some time \n الرجاء الإنتظار',
                                  style: Styles.textStyle14White,
                                  maxLines: 5,
                                ),
                              ),
                            );
                          }
                          //else if (state is FailureDecryptFile) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       backgroundColor: AppColor.kPrimaryColor,
                          //       content: Text(
                          //         state.errMessage,
                          //         style: Styles.textStyle14White,
                          //         maxLines: 5,
                          //       ),
                          //     ),
                          //   );
                          // }
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              for (int i = 0;
                                  i < collegeCubit.level.videos!.length;
                                  i++)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onLongPress: () async {
                                        // final appDocDir = Directory(
                                        //     'storage/emulated/0/video');
                                        final appDocDir =
                                            await getApplicationSupportDirectory();

                                        String fileName =
                                            'video${collegeCubit.level.videos![i].id}.zbr';
                                        final File file =
                                            File('${appDocDir.path}/$fileName');
                                        if (file.existsSync()) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor:
                                                  AppColor.kPrimaryColor,
                                              title: const Text(
                                                'do you want to delete this file?',
                                                style: Styles.textStyle18White,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    // final appDocDir = Directory(
                                                    //     'storage/emulated/0/video');
                                                    final appDocDir =
                                                        await getApplicationSupportDirectory();

                                                    String storageName =
                                                        'video${collegeCubit.level.videos![i].id}.zbr';
                                                    final File file = File(
                                                        '${appDocDir.path}/$storageName');
                                                    if (file.existsSync()) {
                                                      file.deleteSync();
                                                      collegeCubit
                                                          .deleteFileFromFileTable(
                                                        id: collegeCubit.level
                                                            .videos![i].id!,
                                                        storageName:
                                                            storageName,
                                                        type: 'video',
                                                      )
                                                          .then((value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              const AlertDialog(
                                                            backgroundColor:
                                                                AppColor
                                                                    .kPrimaryColor,
                                                            title: Text(
                                                              'Deleted successfully',
                                                              style: Styles
                                                                  .textStyle18White,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    } else {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text(
                                                    'ok',
                                                    style: Styles
                                                        .textStyle15PriCol,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      onPressed: () async {
                                        // MaterialPageRoute(
                                        //   builder: (context) => VideoPlayerScreen(
                                        //     name: collegeCubit.level.name,
                                        //     url:

                                        //         collegeCubit.level.videos![i].url,
                                        //     videoFile: null,
                                        //   ),
                                        // );

                                        //! =================
                                        //! for remove offline mode in video
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                              name: collegeCubit.level.name,
                                              url: collegeCubit
                                                  .level.videos![i].url,
                                              videoFile: null,
                                            ),
                                          ),
                                        );

                                        /*
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor:
                                                AppColor.kPrimaryColor,
                                            title: const Text(
                                              'select type of open videos',
                                              style: Styles.textStyle18White,
                                            ),
                                            content: const Text(
                                              'note: offline mode maybe take more time for open',
                                              style: Styles.textStyle14White,
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                child: const Text('online'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoPlayerScreen(
                                                        name: collegeCubit
                                                            .level.name,
                                                        url: collegeCubit.level
                                                            .videos![i].url,
                                                        videoFile: null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text('offline'),
                                                onPressed: () async {
                                                  // final appDocDir = Directory(
                                                  //     'storage/emulated/0/video');
                                                  final appDocDir =
                                                      await getApplicationSupportDirectory();

                                                  String fileName =
                                                      'video${collegeCubit.level.videos![i].id}.zbr';
                                                  final File file = File(
                                                      '${appDocDir.path}/$fileName');

                                                  if (file.existsSync()) {
                                                    // flutterCompute()
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const AlertDialog(
                                                        content: Text(
                                                            'please wait for open, that maybe take some time'),
                                                      ),
                                                    );

                                                    Timer(
                                                      const Duration(
                                                          seconds: 2),
                                                      () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        collegeCubit
                                                            .decryptFile(
                                                          file: file,
                                                          fileName:
                                                              'video${collegeCubit.level.videos![i].id}',
                                                          type: 'mp4',
                                                        );

                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            // collegeCubit.emit(
                                                            // LoadingDecryptFile());

                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  AppColor
                                                                      .kPrimaryColor,
                                                              title: const Text(
                                                                'please wait',
                                                                style: Styles
                                                                    .textStyle14White,
                                                              ),
                                                              content: BlocConsumer<
                                                                  CollegeCubit,
                                                                  CollegeState>(
                                                                listener: (context,
                                                                    state) async {
                                                                  if (state
                                                                      is SuccessDecryptFile) {
                                                                    final fileInfo =
                                                                        await collegeCubit
                                                                            .cacheManager
                                                                            .getFileFromCache(
                                                                      'video${collegeCubit.level.videos![i].id}',
                                                                    );
                                                                    if (fileInfo !=
                                                                        null) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // ignore: use_build_context_synchronously
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              VideoPlayerScreen(
                                                                            name:
                                                                                collegeCubit.level.name,
                                                                            url:
                                                                                collegeCubit.level.videos![i].url,
                                                                            videoFile:
                                                                                fileInfo.file,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      // print(
                                                                      //     'not exsist');
                                                                    }
                                                                  } else if (state
                                                                      is FailureDownloadFile) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                        backgroundColor:
                                                                            AppColor.kPrimaryColor,
                                                                        content:
                                                                            Text(
                                                                          state
                                                                              .errMessage,
                                                                          style:
                                                                              Styles.textStyle14White,
                                                                          maxLines:
                                                                              5,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                builder:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is LoadingDecryptFile) {
                                                                    return const CustomLoadingIndicator();
                                                                  } else if (state
                                                                      is FailureDecryptFile) {
                                                                    return CustomErrorWidget(
                                                                        errMessage:
                                                                            state.errMessage);
                                                                  }
                                                                  return const SizedBox();
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                     
                                                  } else {
                                                     
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                            */
                                        //!==================
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Icon(Icons.play_arrow),
                                    ),
                                    Text(
                                      collegeCubit.level.videos![i].quality ??
                                          'null in server',
                                      style: Styles.textStyle14White,
                                    ),
                                    /*
                                    ! for remove offline mode for video
                                    Visibility(
                                      visible:
                                          collegeCubit.videoIsDownloaded[i],
                                      child: BlocConsumer<CollegeCubit,
                                          CollegeState>(
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
                                            backgroundColor:
                                                AppColor.kPrimaryColor,
                                            percent: collegeCubit
                                                    .videoDownloadBytes[i] /
                                                collegeCubit
                                                    .maxVideoDownloadBytes[i],
                                            center: Text(
                                              (collegeCubit.maxVideoDownloadBytes[
                                                          i] ==
                                                      0)
                                                  ? '0%'
                                                  : '${((collegeCubit.videoDownloadBytes[i] / collegeCubit.maxVideoDownloadBytes[i]) * 100).toStringAsFixed(0)}%',
                                              style:
                                                  Styles.textStyle12.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.red.withOpacity(0.7),
                                              ),
                                            ),
                                            radius: 20,
                                          );
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          !collegeCubit.videoIsDownloaded[i],
                                      child: IconButton(
                                        onPressed: () {
                                          collegeCubit.downloadEncryptedFile(
                                            courseID:
                                                collegeCubit.level.courseId!,
                                            levelID: collegeCubit.level.id!,
                                            fileName:
                                                'video ${collegeCubit.level.name!} - ${collegeCubit.level.videos![i].quality}',
                                            isVideo: true,
                                            fileID: collegeCubit
                                                .level.videos![i].id!,
                                            type: 'video',
                                            index: i,
                                            storageName:
                                                'video${collegeCubit.level.videos![i].id}.zbr',
                                            fileUrl: collegeCubit
                                                .level.videos![i].url!,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  */
                                  ],
                                ),
                              // },
                              // ),
                            ],
                          );
                        },
                      )),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/image/playAmin2.png',
                  // 'assets/gifImage/video.gif',
                  height: 75,
                ),
              ),
              const Text(
                'show video',
                style: Styles.textStyle20White,
              ),
            ],
          ),
          const Divider(
            thickness: 5,
          ),
          Expanded(
            child: BlocConsumer<CollegeCubit, CollegeState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is FileIsExistStatePdf) {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      backgroundColor: AppColor.kPrimaryColor,
                      title: Text(
                        'This file has already been downloaded',
                        style: Styles.textStyle18White,
                      ),
                    ),
                  );
                } else if (state is FailureDecryptFilePdf) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColor.kPrimaryColor,
                      content: Text(
                        state.errMessage,
                        style: Styles.textStyle14White,
                        maxLines: 5,
                      ),
                    ),
                  );
                } else if (state is AlertDecryptFile) {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      backgroundColor: AppColor.kPrimaryColor,
                      content: Text(
                        'please wait sometime',
                        style: Styles.textStyle14White,
                        maxLines: 5,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 30,
                    childAspectRatio:
                        2 / 3, //(collegeCubit.isSelectMode) ? 2 / 3 : 1,
                  ),
                  itemCount: collegeCubit.level.pdfs?.length ?? 0,
                  itemBuilder: (context, index) => Material(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onLongPress: () async {
                              // final appDocDir =
                              //     Directory('storage/emulated/0/video');
                              final appDocDir =
                                  await getApplicationSupportDirectory();

                              String storageName =
                                  'pdf${collegeCubit.level.pdfs![index].id}.zbr';
                              final File file =
                                  File('${appDocDir.path}/$storageName');
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
                                          // final appDocDir = Directory(
                                          //   'storage/emulated/0/video',
                                          // );
                                          final appDocDir =
                                              await getApplicationSupportDirectory();

                                          String storageName2 =
                                              'pdf${collegeCubit.level.pdfs![index].id}.zbr';
                                          final File file = File(
                                              '${appDocDir.path}/$storageName2');
                                          if (file.existsSync()) {
                                            file.deleteSync();
                                            collegeCubit
                                                .deleteFileFromFileTable(
                                                    id: collegeCubit
                                                        .level.pdfs![index].id!,
                                                    storageName: storageName2,
                                                    type: 'pdf')
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AlertDialog(
                                                  backgroundColor:
                                                      AppColor.kPrimaryColor,
                                                  title: Text(
                                                    'Deleted successfully',
                                                    style:
                                                        Styles.textStyle18White,
                                                  ),
                                                ),
                                              );
                                            });
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
                            onTap: () async {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => PdfViewerPage(
                              //       url: collegeCubit.level.pdfs![index].url ??
                              //           '',
                              //     ),
                              //   ),
                              // );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocBuilder<CollegeCubit,
                                      CollegeState>(
                                    builder: (context, state) {
                                      return AlertDialog(
                                        backgroundColor: AppColor.kPrimaryColor,
                                        title: const Text(
                                          'select type of open pdf',
                                          style: Styles.textStyle18White,
                                        ),
                                        content: const Text(
                                          'note: offline mode maybe take more time for open',
                                          style: Styles.textStyle14White,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            child: const Text('online'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewerPage(
                                                    url: collegeCubit.level
                                                        .pdfs![index].url!,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (collegeCubit
                                                  .pdfIsDownloaded[index])
                                                BlocConsumer<CollegeCubit,
                                                    CollegeState>(
                                                  listener: (context, state) {
                                                    // TODO: implement listener
                                                  },
                                                  builder: (context, state) {
                                                    return CircularPercentIndicator(
                                                      // animation: true,
                                                      // animationDuration: 2000,
                                                      // lineHeight: 20,
                                                      // barRadius: const Radius.circular(10),
                                                      progressColor: AppColor
                                                          .kPrimaryColor, //Colors.white,
                                                      backgroundColor: Colors
                                                          .white, // AppColor.kPrimaryColor,
                                                      percent: (collegeCubit
                                                                      .maxPdfDownloadBytes[
                                                                  index] ==
                                                              0)
                                                          ? 0
                                                          : collegeCubit
                                                                      .pdfDownloadBytes[
                                                                  index] /
                                                              collegeCubit
                                                                      .maxPdfDownloadBytes[
                                                                  index],
                                                      center: Text(
                                                        (collegeCubit.maxPdfDownloadBytes[
                                                                    index] ==
                                                                0)
                                                            ? '0%'
                                                            : '${((collegeCubit.pdfDownloadBytes[index] / collegeCubit.maxPdfDownloadBytes[index]) * 100).toStringAsFixed(0)}%',
                                                        style: Styles
                                                            .textStyle12
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                      radius: 20,
                                                    );
                                                  },
                                                ),
                                              if (!collegeCubit
                                                  .pdfIsDownloaded[index])
                                                IconButton(
                                                  onPressed: () {
                                                    collegeCubit
                                                        .downloadEncryptedFile(
                                                      courseID: collegeCubit
                                                          .level.courseId!,
                                                      levelID: collegeCubit
                                                          .level.id!,
                                                      storageName:
                                                          'pdf${collegeCubit.level.pdfs![index].id}.zbr',
                                                      isVideo: false,
                                                      fileID: collegeCubit.level
                                                          .pdfs![index].id!,
                                                      type: 'pdf',
                                                      index: index,
                                                      fileName:
                                                          'pdf ${collegeCubit.level.name!} - ${index + 1}',
                                                      fileUrl: collegeCubit
                                                          .level
                                                          .pdfs![index]
                                                          .url!,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.download,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ElevatedButton(
                                                child: const Text('offline'),
                                                onPressed: () async {
                                                  // final appDocDir = Directory(
                                                  //   'storage/emulated/0/video',
                                                  // );
                                                  final appDocDir =
                                                      await getApplicationSupportDirectory();

                                                  String fileName =
                                                      'pdf${collegeCubit.level.pdfs![index].id}.zbr';
                                                  final File file = File(
                                                      '${appDocDir.path}/$fileName');

                                                  // int fff(int x) {
                                                  //   collegeCubit.decryptFile(
                                                  //     file: file,
                                                  //     fileName:
                                                  //         'pdf${collegeCubit.level.pdfs![index].id}',
                                                  //     type: 'pdf',
                                                  //   );
                                                  //   return 5
                                                  // }

                                                  // void encryptFile(int x) {
                                                  //   collegeCubit.decryptFile(
                                                  //     file: file,
                                                  //     fileName:
                                                  //         'pdf${collegeCubit.level.pdfs![index].id}',
                                                  //     type: 'pdf', //'pdf',
                                                  //   );
                                                  // }

                                                  if (file.existsSync()) {
                                                    // flutterCompute(encryptFile, 100);

                                                    // print(
                                                    //     '5555555555555555555555555555');
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const AlertDialog(
                                                        content: Text(
                                                            'please wait for open, that maybe take some time'),
                                                      ),
                                                    );
                                                    Timer(
                                                        const Duration(
                                                            seconds: 2), () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      collegeCubit.decryptFile(
                                                        file: file,
                                                        fileName:
                                                            'pdf${collegeCubit.level.pdfs![index].id}',
                                                        type: 'pdf', //'pdf',
                                                      );

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          // collegeCubit.emit(
                                                          // LoadingDecryptFile());

                                                          return AlertDialog(
                                                            backgroundColor:
                                                                AppColor
                                                                    .kPrimaryColor,
                                                            title: const Text(
                                                              'please wait',
                                                              style: Styles
                                                                  .textStyle14White,
                                                            ),
                                                            content: BlocConsumer<
                                                                CollegeCubit,
                                                                CollegeState>(
                                                              listener: (context,
                                                                  state) async {
                                                                if (state
                                                                    is SuccessDecryptFile) {
                                                                  final fileInfo =
                                                                      await collegeCubit
                                                                          .cacheManager
                                                                          .getFileFromCache(
                                                                    'pdf${collegeCubit.level.pdfs![index].id}',
                                                                  );
                                                                  if (fileInfo !=
                                                                      null) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    // ignore: use_build_context_synchronously
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                PdfViewerPage(
                                                                          url: collegeCubit.level.pdfs![index].url ??
                                                                              '',
                                                                          pdfFIle:
                                                                              fileInfo.file,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    // print(
                                                                    //     'not exsist');
                                                                  }
                                                                }
                                                              },
                                                              builder: (context,
                                                                  state) {
                                                                if (state
                                                                    is LoadingDecryptFile) {
                                                                  return const CustomLoadingIndicator();
                                                                } else if (state
                                                                    is FailureDecryptFile) {
                                                                  return CustomErrorWidget(
                                                                    errMessage:
                                                                        state
                                                                            .errMessage,
                                                                  );
                                                                }
                                                                return const SizedBox();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                  } else {}
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );

                              /*
                              final appDocDir =
                                  Directory('storage/emulated/0/video');
                              String fileName =
                                  'pdf${collegeCubit.level.pdfs![index].id}.zbr';
                              final File file =
                                  File('${appDocDir.path}/$fileName');
                               

                              if (file.existsSync()) {
                                collegeCubit
                                    .decryptFile(
                                  file: file,
                                  fileName:
                                      'pdf${collegeCubit.level.pdfs![index].id}',
                                  type: 'pdf',
                                )
                                    .then((value) async {
                                  final fileInfo = await collegeCubit
                                      .cacheManager
                                      .getFileFromCache(
                                    'pdf${collegeCubit.level.pdfs![index].id}',
                                  );
                                });

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    // collegeCubit.emit(
                                    // LoadingDecryptFile());
                                    return AlertDialog(
                                      backgroundColor: AppColor.kPrimaryColor,
                                      title: const Text(
                                        'please wait',
                                        style: Styles.textStyle14White,
                                      ),
                                      content: BlocConsumer<CollegeCubit,
                                          CollegeState>(
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewerPage(
                                                        url: collegeCubit.level
                                                            .pdfs![index].url!,
                                                      )
                                                  //     PdfViewerPage(
                                                  //   collegeCubit: collegeCubit,
                                                  //   pdfName:
                                                  //       'pdf${collegeCubit.level.pdfs![index].id}',
                                                  //   pdfType: 'pdf',
                                                  // ),
                                                  ),
                                            );
                                            // } else {
                                            //    
                                            // }
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is LoadingDecryptFile) {
                                            return const CustomLoadingIndicator();
                                          } else if (state
                                              is FailureDecryptFile) {
                                            return CustomErrorWidget(
                                              errMessage: state.errMessage,
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    );
                                  },
                                );

                                 
                              } else {
                                 
                              }
                              */
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    const Expanded(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/image/pdf.png',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (index + 1).toString(),
                                      style: Styles.textStyle25PriCol,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // if (collegeCubit.isSelectMode)
                        //   Checkbox(
                        //     // checkColor: AppColor.kPrimaryColor,
                        //     activeColor: AppColor.kPrimaryColor,
                        //     value: collegeCubit.selectedList[index],
                        //     onChanged: (value) {
                        //       collegeCubit.selectedList[index] = value!;
                        //       collegeCubit.emit(SuccessGetLevelState());
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/core/widgets/custom_no_data_widget.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/pdf_viewer_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class PdfAndVideoLibrary extends StatelessWidget {
  const PdfAndVideoLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'library',
            style: Styles.textStyle18White,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            // const TabBar(
            //   tabs: [
            Tab(
              icon: Image(
                image: AssetImage(
                  'assets/image/pdf.png',
                ),
                height: 30,
              ),
              child: Text('pdf'),
            ),
            // Tab(
            //   icon: Image(
            //     image: AssetImage(
            //       'assets/image/video.png',
            //     ),
            //     height: 30,
            //   ),
            //   child: Text('video'),
            // ),
            //   ],
            // ),
            Expanded(
              child:
                  // TabBarView(
                  //   children: [
                  // TabBar for PDf
                  BlocConsumer<CollegeCubit, CollegeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AppGetDatabaseLoadingState ||
                      state is LoadingDeleteRowFromDatabaseState) {
                    return const CustomLoadingIndicator(
                      color: AppColor.kPrimaryColor,
                    );
                  } else if (state is AppFailureGetDatabaseState) {
                    return CustomErrorWidget(
                      errMessage:
                          'there is an error in fetch local database: ${state.errMessage}',
                    );
                  } else if (state is FailureDeleteRowFromDatabaseState) {
                    return CustomErrorWidget(
                      errMessage:
                          'there is an error in fetch local database: ${state.errMessage}',
                    );
                  } else if (collegeCubit.pdfFile.isEmpty) {
                    return const CustomNoDataWidget();
                  } else {
                    return ListView.builder(
                      itemCount: collegeCubit.pdfFile.length,
                      itemBuilder: (context, index) => Card(
                        color: AppColor.kPrimaryColor,
                        child: ListTile(
                          onTap: () async {
                            // final appDocDir = Directory(
                            //   'storage/emulated/0/video',
                            // );
                            final appDocDir =
                                await getApplicationSupportDirectory();

                            String storageName =
                                collegeCubit.pdfFile[index].storageName!;
                            final File file =
                                File('${appDocDir.path}/$storageName');

                            if (file.existsSync()) {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text(
                                      'please wait for open, that maybe take some time'),
                                ),
                              );
                              Timer(const Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                                collegeCubit.decryptFile(
                                  file: file,
                                  fileName: storageName,
                                  type: 'pdf', //'pdf',
                                );

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
                                            final fileInfo = await collegeCubit
                                                .cacheManager
                                                .getFileFromCache(
                                              storageName,
                                            );
                                            if (fileInfo != null) {
                                              Navigator.of(context).pop();
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PdfViewerPage(
                                                    url: '',
                                                    pdfFIle: fileInfo.file,
                                                  ),
                                                ),
                                              );
                                            } else {}
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
                              });
                            } else {}
                          },
                          title: Text(
                            collegeCubit.pdfFile[index].fileName!,
                            // textAlign: TextAlign.center,
                            style: Styles.textStyle18White,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColor.kPrimaryColor,
                                  content: const Text(
                                    'do you sure to delete this file',
                                    style: Styles.textStyle18White,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          File file = File(
                                            collegeCubit.pdfFile[index].path!,
                                          );
                                          file.deleteSync();

                                          await collegeCubit
                                              .deleteFileFromFileTable(
                                            id: collegeCubit.pdfFile[index].id!,
                                            storageName: collegeCubit
                                                .pdfFile[index].storageName!,
                                            type: collegeCubit
                                                .pdfFile[index].type!,
                                          );
                                          Navigator.of(context).pop();
                                        } catch (e) {}
                                      },
                                      child: const Text(
                                        'ok',
                                        style: Styles.textStyle15PriCol,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),

              // TabBar for Video
              /*
                  BlocConsumer<CollegeCubit, CollegeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is AppGetDatabaseLoadingState ||
                          state is LoadingDeleteRowFromDatabaseState) {
                        return const CustomLoadingIndicator(
                          color: AppColor.kPrimaryColor,
                        );
                      } else if (state is AppFailureGetDatabaseState) {
                        return CustomErrorWidget(
                          errMessage:
                              'there is an error in fetch local database: ${state.errMessage}',
                        );
                      } else if (state is FailureDeleteRowFromDatabaseState) {
                        return CustomErrorWidget(
                          errMessage:
                              'there is an error in fetch local database: ${state.errMessage}',
                        );
                      } else if (collegeCubit.videoFile.isEmpty) {
                        return const CustomNoDataWidget(
                          size: 30,
                        );
                      } else {
                        return ListView.builder(
                          itemCount: collegeCubit.videoFile.length,
                          itemBuilder: (context, index) => Card(
                            color: AppColor.kPrimaryColor,
                            child: ListTile(
                              onTap: () async {
                                // print(
                                //     collegeCubit.videoFile[index].storageName);
                                // final appDocDir =
                                //     Directory('storage/emulated/0/video');
                                final appDocDir =
                                    await getApplicationSupportDirectory();

                                String storageName =
                                    collegeCubit.videoFile[index].storageName!;
                                final File file =
                                    File('${appDocDir.path}/$storageName');
                                if (file.existsSync()) {
                                  // flutterCompute()
                                  showDialog(
                                    context: context,
                                    builder: (context) => const AlertDialog(
                                      content: Text(
                                          'please wait for open, that maybe take some time'),
                                    ),
                                  );

                                  Timer(
                                    Duration(seconds: 1),
                                    () {
                                      Navigator.of(context).pop();
                                      collegeCubit.decryptFile(
                                        file: file,
                                        fileName: storageName,
                                        type: 'mp4',
                                      );

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
                                                  final fileInfo =
                                                      await collegeCubit
                                                          .cacheManager
                                                          .getFileFromCache(
                                                    storageName,
                                                  );

                                                  if (fileInfo != null) {
                                                    Navigator.of(context).pop();
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoPlayerScreen(
                                                          name: collegeCubit
                                                              .videoFile[index]
                                                              .fileName,
                                                          url: '',
                                                          videoFile:
                                                              fileInfo.file,
                                                        ),
                                                      ),
                                                    );
                                                  } else {}
                                                } else if (state
                                                    is FailureDownloadFile) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor: AppColor
                                                          .kPrimaryColor,
                                                      content: Text(
                                                        state.errMessage,
                                                        style: Styles
                                                            .textStyle14White,
                                                        maxLines: 5,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              builder: (context, state) {
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
                                } else {}
                              },
                              title: Text(
                                collegeCubit.videoFile[index].fileName!,
                                // textAlign: TextAlign.center,
                                style: Styles.textStyle18White,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppColor.kPrimaryColor,
                                      content: const Text(
                                        'do you sure to delete this file',
                                        style: Styles.textStyle18White,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () async {
                                            try {
                                              File file = File(
                                                collegeCubit
                                                    .videoFile[index].path!,
                                              );
                                              file.deleteSync();

                                              await collegeCubit
                                                  .deleteFileFromFileTable(
                                                id: collegeCubit
                                                    .videoFile[index].id!,
                                                storageName: collegeCubit
                                                    .videoFile[index]
                                                    .storageName!,
                                                type: collegeCubit
                                                    .videoFile[index].type!,
                                              );
                                              Navigator.of(context).pop();
                                            } catch (e) {}
                                          },
                                          child: const Text(
                                            'ok',
                                            style: Styles.textStyle15PriCol,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                    */
              // seconde tab bar
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/core/widgets/custom_no_data_widget.dart';
import 'package:alaminedu/features/JCI/presentation/manager/jci_cubit/jci_cubit.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/lesson_details_page.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/level_page.dart';
// import 'package:alaminedu/features/JCI/presentation/manager/cubit/jci_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JCILessonHomePages extends StatelessWidget {
  const JCILessonHomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          // '${Constants.yearName[yearIndex]} Subjects',
          "JCI lessons",
          style: Styles.textStyle20White,
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
      body: const JCILessonHomePageBody(),
    );
  }
}

class JCILessonHomePageBody extends StatelessWidget {
  const JCILessonHomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    JciCubit jciCubit = JciCubit.get(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 10,
        start: 10,
        end: 10,
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: Constants.listViewDecoration,
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<JciCubit, JciState>(
          builder: (context, state) {
            if (state is LoadingGetLessonsState) {
              return const CustomLoadingIndicator(
                color: AppColor.kPrimaryColor,
              );
            } else if (state is FailureGetLessonsState) {
              return CustomErrorWidget(
                errMessage: state.errMessage,

                // iconColor: AppColor.kPrimaryColor,
              );
            } else {
              if (jciCubit.jciLesson.isEmpty) {
                return const CustomNoDataWidget();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: jciCubit.jciLesson.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // BlocProvider.of<CollegeCubit>(context).fetchCourseTimeLine(
                    //   courseID: jciCubit.jciLesson[index].id ?? -1,
                    // );
                    // BlocProvider.of<CollegeCubit>(context).fetchLevel(
                    //   levelID: jciCubit.jciLesson[index].id ?? -1,
                    // );
                    //
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => LevelPage(
                    //       levelID: jciCubit.jciLesson[index].id ?? -1,
                    //     ),
                    //   ),
                    // );

                    BlocProvider.of<CollegeCubit>(context).fetchCourseTimeLine(
                      courseID: jciCubit.jciLesson[index].id ?? -1,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LessonDetailsPage(
                          courseID: jciCubit.jciLesson[index].id ?? -1,
                          courseName: jciCubit.jciLesson[index].name ?? "",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/image/lesson.png',
                                  width: 40,
                                  height: 32,
                                )),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: AppColor.kPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12))),
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  jciCubit.jciLesson[index].name ?? "",
                                  style: Styles.textStyle14White,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

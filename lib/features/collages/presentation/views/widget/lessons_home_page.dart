import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/lesson_details_page.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/color_app.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/widgets/custom_no_data_widget.dart';
import '../data/course_api.dart';
import '../data/course_model.dart';
// import 'college_years_page.dart';

class LessonsHomePage extends StatelessWidget {
  const LessonsHomePage({
    super.key,
    required this.yearIndex,
    required this.yearID,
    this.nameIfNotFromYear,
    this.numberOfType,
  });
  final int? yearIndex;
  final int? yearID;
  final String? nameIfNotFromYear;
  final int? numberOfType;

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    String title = (nameIfNotFromYear != null)
        ? nameIfNotFromYear! //'External Courses'
        : '${Constants.yearName[yearIndex!]} Subjects';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          // '${Constants.yearName[yearIndex]} Subjects',
          title,
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
      body: Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 10,
          start: 10,
          end: 10,
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: Constants.listViewDecoration,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<CourseList>(
            future: (nameIfNotFromYear != null)
                ? CourseApi.fetchExternalCoursesAndNewCourse(
                    typeQuery: numberOfType)
                : CourseApi.fetchCourses(yearID: yearID!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CustomLoadingIndicator(
                        color: AppColor.kPrimaryColor,
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data!.data.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomNoDataWidget(),
                  ],
                );
              } else {
                final List<Course> courses = snapshot.data!.data;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
                        collegeCubit.fetchCourseTimeLine(
                          courseID: courses[index].id!,
                        );
                        debugPrint('courses[index].id: ${courses[index].id}');

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LessonDetailsPage(
                              courseID: course.id!,
                              courseName: course.name!,
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
                                      course.name!,
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
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

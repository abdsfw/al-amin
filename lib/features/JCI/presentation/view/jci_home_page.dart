import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/core/widgets/custom_no_data_widget.dart';
import 'package:alaminedu/features/JCI/presentation/manager/jci_cubit/jci_cubit.dart';
import 'package:alaminedu/features/JCI/presentation/view/jci_lesson_home_page.dart';
// import 'package:alaminedu/features/JCI/presentation/manager/cubit/jci_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JCIHomePage extends StatelessWidget {
  const JCIHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          // '${Constants.yearName[yearIndex]} Subjects',
          title, //"JCI",
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
      body: const JCIHomePageBody(),
    );
  }
}

class JCIHomePageBody extends StatelessWidget {
  const JCIHomePageBody({
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
            if (state is LoadingGetCategoryState) {
              return const CustomLoadingIndicator(
                color: AppColor.kPrimaryColor,
              );
            } else if (state is FailureGetCategoryState) {
              return CustomErrorWidget(
                errMessage: state.errMessage,
                // iconColor: AppColor.kPrimaryColor,
              );
            } else {
              if (jciCubit.jciCategory.isEmpty) {
                return const CustomNoDataWidget();
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: jciCubit.jciCategory.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    // collegeCubit.fetchCourseTimeLine(
                    //   courseID: courses[index].id!,
                    // );

                    //

                    jciCubit.getAllJCILessonForCategory(
                        categoryID: jciCubit.jciCategory[index].id ?? -1);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const JCILessonHomePages(),
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
                                  jciCubit.jciCategory[index].name ?? "",
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

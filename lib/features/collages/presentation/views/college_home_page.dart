import 'package:alaminedu/constants.dart';
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/college_years_page.dart';
// import 'package:alaminedu/features/collages/presentation/views/widget/lessons_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_Loading_indicator.dart';
import '../../../login/log_in_page.dart';

class CollegeHomePage extends StatelessWidget {
  const CollegeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'colleges',
          style: Styles.textStyle20White,
        ),
        centerTitle: true,
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
          child: BlocConsumer<CollegeCubit, CollegeState>(
            listener: (context, state) {
              // showDialog(
              //   context: context,
              //   builder: (context) => const AlertDialog(
              //     title: Text(
              //       'sorry!!\nYour account has been deleted, please check with your manager.',
              //     ),
              //   ),
              // );
              if (state is FailureFetchCollegesState) {
                if (state.statusCode == 403 || state.statusCode == 401) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'sorry!\nYour account has been deleted, please check with your manager.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                    phoneFromSingin: "",
                                    userNameFromSingin: "",
                                  ),
                                ),
                                (route) => false);
                          },
                          child: const Text(
                            'ok',
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is LoadingFetchCollegesState) {
                return const CustomLoadingIndicator(
                  color: AppColor.kPrimaryColor,
                );
              } else if (state is FailureFetchCollegesState) {
                return CustomErrorWidget(
                  errMessage: state.errMessage,
                  // iconColor: AppColor.kPrimaryColor,
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 13,
                  ),
                  itemBuilder: (context, collegeIndex) => Material(
                    // color: AppColor.kPinkCustomColor,
                    color: Colors.white,
                    borderRadius: Constants.borderRadius10,
                    child: InkWell(
                      borderRadius: Constants.borderRadius10,
                      splashColor: AppColor.kSplashColor,
                      onTap: () {
                        collegeCubit.fetchYears(
                          collegeID: collegeCubit.colleges[collegeIndex].id!,
                        );
                        // print(
                        // 'college ID:  ${collegeCubit.colleges[collegeIndex].id.toString()}');

                        showDialog(
                          context: context,
                          builder: (context) => CollegeYearsPage(
                            collegeIndex: collegeIndex,
                            collegeID: collegeCubit.colleges[collegeIndex].id!,
                          ),
                        );
                      },
                      // onLongPress: () {},

                      child: ListTile(
                        title: Text(
                          collegeCubit.colleges[collegeIndex].name!,
                          style: Styles.textStyle20,
                        ),
                        trailing: const Icon(Icons.school_sharp),
                      ),
                    ),
                  ),
                  itemCount: collegeCubit.colleges.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

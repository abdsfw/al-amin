// old code

/*
import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/collages/presentation/views/widget/lessons_home_page.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class CollegeYearsPage extends StatelessWidget {
  const CollegeYearsPage({super.key, required this.collegeIndex});
  final int collegeIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'years',
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
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, yearIndex) => InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LessonsHomePage(
                  yearIndex: yearIndex,
                ),
              ),
            );
          },
          child: Card(
            color: AppColor.kFordColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  child: Image(
                    image: AssetImage(
                      Constants.photoNumber[yearIndex],
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  Constants.yearName[yearIndex],
                  style: Styles.textStyle20,
                ),
              ],
            ),
          ),
        ),
        itemCount: 5,
      ),
    );
  }
}
*/

import 'package:alaminedu/core/cache/cashe_helper.dart';
import 'package:alaminedu/core/widgets/custom_Loading_indicator.dart';
import 'package:alaminedu/core/widgets/custom_error_widget.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:alaminedu/features/login/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../core/utils/color_app.dart';
import '../../../../../core/utils/styles.dart';
import 'lessons_home_page.dart';

class CollegeYearsPage extends StatelessWidget {
  const CollegeYearsPage({
    super.key,
    required this.collegeIndex,
    required this.collegeID,
  });
  final int collegeIndex;
  final int collegeID;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'years',
              style: Styles.textStyle20,
            ),
            const Divider(),
            Expanded(
              child: BlocConsumer<CollegeCubit, CollegeState>(
                listener: (context, state) {
                  if (state is FailureFetchYearsState) {
                    if (state.statusCode == 403 || state.statusCode == 401) {
                      CasheHelper.deleteData(key: Constants.kToken);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                phoneFromSingin: "", userNameFromSingin: ""),
                          ),
                          (route) => false);
                    }
                    //
                  }
                },
                builder: (context, state) {
                  if (state is LoadingFetchYearsState) {
                    return const CustomLoadingIndicator(
                      color: AppColor.kPrimaryColor,
                    );
                  } else if (state is FailureFetchYearsState) {
                    return CustomErrorWidget(
                      errMessage: state.errMessage,
                      iconColor: AppColor.kPrimaryColor,
                      textStyle: Styles.textStyle20PriCol,
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 20,
                      ),
                      itemBuilder: (context, yearIndex) => InkWell(
                        splashColor: AppColor.kSplashColor,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          // for close dialog before go to next page
                          // print(
                          //     'year ID : ${collegeCubit.collegeYears[yearIndex].id.toString()}');
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonsHomePage(
                                yearIndex: yearIndex,
                                yearID:
                                    collegeCubit.collegeYears[yearIndex].id!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.kPrimaryColor,
                                radius: 35,
                                child: Image(
                                  image: AssetImage(
                                    // Constants.photoNumber[yearIndex],
                                    '${Constants.kDynamicPhoto}${collegeCubit.collegeYears[yearIndex].year.toString()}.png',
                                    // 'assets/image/number-third.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                // Constants.yearName[yearIndex],
                                collegeCubit.collegeYears[yearIndex].year!,
                                style: Styles.textStyle15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: collegeCubit.collegeYears.length,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

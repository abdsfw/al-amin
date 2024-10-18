import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../data/models/all_quiz_model/all_quiz_model.dart';

class ResultPage extends StatelessWidget {
  const ResultPage(
      {super.key,
      required this.fullMark,
      required this.examMark,
      required this.successMark,
      required this.courseID});
  final int fullMark;
  final int examMark;
  final int successMark;
  final int courseID;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    return Scaffold(
      // backgroundColor: AppColor.kPrimaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            collegeCubit.fetchCourseTimeLine(
              courseID: courseID,
            );
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
        margin:
            const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
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
              const SizedBox(
                width: double.infinity,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'fullMark: $fullMark',
                        style: Styles.textStyle25PriCol,
                      ),
                      Text('examMark: $examMark',
                          style: Styles.textStyle25PriCol),
                      Text('successMark: $successMark',
                          style: Styles.textStyle25PriCol),
                    ],
                  ),
                ),
              ),
              BlocBuilder<CollegeCubit, CollegeState>(
                builder: (context, state) {
                  if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark == 'success') {
                    return const Center(
                      child: Image(
                        image: AssetImage(
                          'assets/image/checked.png',
                        ),
                        height: 50,
                      ),
                    );
                  } else if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark == 'failed') {
                    return const Center(
                      child: Image(
                        image: AssetImage(
                          'assets/image/cancel.png',
                        ),
                        height: 50,
                      ),
                    );
                  } else if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark == 'passed') {
                    return const Center(
                      child: Text(
                        'you passed this quiz before , your mark will still your old one',
                        style: Styles.textStyle25PriCol,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark == 'finished') {
                    return const Center(
                      child: Text(
                        'you has finished this course!',
                        style: Styles.textStyle25PriCol,
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                  /*
                  if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark['data'] == 'success') {
                    return const Center(
                      child: Image(
                        image: AssetImage(
                          'assets/image/checked.png',
                        ),
                        height: 50,
                      ),
                    );
                  } else if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark['data']== 'failed' ) {
                    return const  Center(
                      child: Image(
                        image: AssetImage(
                          'assets/image/cancel.png',
                        ),
                        height: 50,
                      ),
                    );
                  } else if(state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark['data'] == 'passed') {
                  return  const Center(
                      child: Text('you passed this quiz before , your mark will still your old one'),
                    );

                  }else if (state is SuccessAddMarkState &&
                      collegeCubit.resultOfMark['data'] == 'finished'){
                    const Center(
                      child: Text('you has finished this course!'),
                    );
                  }else{return const SizedBox();}

                   */
                },
              )
            ],
          ),
        ),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       'fullMark: $fullMark',
      //       style: Styles.textStyle18White,
      //     ),
      //     Text('examMark: $examMark', style: Styles.textStyle18White),
      //     Text('successMark: $successMark', style: Styles.textStyle18White),
      //   ],
      // ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants.dart';
import 'color_app.dart';

abstract class Styles {
  static const textStyle25White = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle18White = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle25grey = TextStyle(
    fontSize: 25,
    // fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 189, 189, 189),
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle18 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'Cairo',
  );
  static const textStyle35 = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
    fontFamily: 'Cairo',
  );

  static const textStyle14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Cairo',
  );
  static const textStyle12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'Cairo',
  );
  static const textStyle16 = TextStyle(
    fontSize: 16,
    // fontWeight: FontWeight.w600,
    // color: Colors.white,
    fontFamily: Constants.kCairoFont,
  );

  static const textStyle14White = TextStyle(
    fontSize: 14,

    // fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle14grey = TextStyle(
    fontSize: 14,

    // fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 189, 189, 189),
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle18grey = TextStyle(
    fontSize: 18,

    // fontWeight: FontWeight.w600,
    color: Color.fromARGB(255, 189, 189, 189),
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle20 = TextStyle(
    fontSize: 20,

    // fontWeight: FontWeight.w600,
    // color: Color.fromARGB(255, 189, 189, 189),
    fontFamily: Constants.kCairoFont,
  );

  static const textStyle20White = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    fontFamily: Constants.kCairoFont,
  );

  static const textStyle20Black = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle20PriCol = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColor.kPrimaryColor,
    fontFamily: Constants.kCairoFont,
  );

  static const textStyle15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle25PriCol = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: AppColor.kPrimaryColor,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle40SecCol = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: AppColor.kFifthColor,
    fontFamily: Constants.kCairoFont,
  );
  static const textStyle15PriCol = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColor.kPrimaryColor,
    fontFamily: Constants.kCairoFont,
  );
  // static const textStyle16 = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle14 = TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.bold,
  //   fontFamily: Constants.kCairoFont,
  // );

  // static const textStyle13gr = TextStyle(
  //   fontSize: 13,
  //   fontWeight: FontWeight.w600,
  //   color: AppColors.green1,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle13White = TextStyle(
  //   fontSize: 13,
  //   fontWeight: FontWeight.w600,
  //   color: Colors.white,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle13 = TextStyle(
  //   fontSize: 13,
  //   fontWeight: FontWeight.w600,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle10 = TextStyle(
  //   fontSize: 10,
  //   fontWeight: FontWeight.w600,
  //   // color: AppColors.green1
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle12 = TextStyle(
  //   fontSize: 12,
  //   fontWeight: FontWeight.w600,
  //   // color: AppColors.green1
  //   fontFamily: Constants.kCairoFont,
  // );

  // static const textStyle18White = TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w600,
  //   fontFamily: Constants.kCairoFont,
  //   color: AppColors.white,
  // );
  // static const textStyle16White = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  //   fontFamily: Constants.kCairoFont,
  //   color: AppColors.white,
  // );

  // static const textStyle20White = TextStyle(
  //   fontSize: 20,
  //   fontWeight: FontWeight.bold,
  //   color: AppColors.white,
  //   fontFamily: Constants.kCairoFont,
  // );

  // static const textStyle25 = TextStyle(
  //   fontSize: 25,
  //   fontWeight: FontWeight.normal,
  //   fontFamily: Constants.kCairoFont,
  // );

  // static const textStyle144 = TextStyle(
  //   fontSize: 14,
  //   fontWeight: FontWeight.normal,
  //   color: Color.fromARGB(255, 219, 218, 218),
  //   fontFamily: Constants.kCairoFont,
  // );

  // static TextStyle? textStyle15 = TextStyle(
  //   fontSize: 15,
  //   // fontWeight: FontWeight.w500,
  //   color: AppColors.white.withOpacity(.6),
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const TextStyle textStyle15SB = TextStyle(
  //   fontSize: 15,
  //   fontWeight: FontWeight.w500,
  //   // color: AppColors.white,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static TextStyle? textStyle15White = const TextStyle(
  //   fontSize: 15,
  //   // fontWeight: FontWeight.w500,
  //   color: AppColors.white,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static TextStyle? textStyle15Black = const TextStyle(
  //   fontSize: 15,
  //   // fontWeight: FontWeight.w500,
  //   color: AppColors.black,
  //   fontFamily: Constants.kCairoFont,
  // );

  // static const textStyle30 = TextStyle(
  //   fontSize: 30,
  //   fontWeight: FontWeight.bold,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle23DarkGreen = TextStyle(
  //   color: AppColors.darkGreen1,
  //   fontSize: 23,
  //   fontWeight: FontWeight.w500,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle17DarkGreen = TextStyle(
  //   color: AppColors.darkGreen1,
  //   fontSize: 17,
  //   fontWeight: FontWeight.w500,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle15DarkGreen = TextStyle(
  //   color: AppColors.darkGreen1,
  //   fontSize: 15,
  //   fontWeight: FontWeight.w500,
  //   fontFamily: Constants.kCairoFont,
  // );
  // static const textStyle15Green1 = TextStyle(
  //   color: AppColors.green1,
  //   fontSize: 15,
  //   fontWeight: FontWeight.bold,
  //   fontFamily: Constants.kCairoFont,
  // );
}

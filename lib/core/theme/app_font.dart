import 'package:e_health/core/theme/app_color.dart';
import 'package:flutter/cupertino.dart';

class AppFonts {
  AppFonts._();

  static String fontFamily = "Inter";

  static const double fontSize11 = 11.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize22 = 22.0;
  static const double fontSize32 = 32.0;

  // Font weights
  static const FontWeight fontWeight400 = FontWeight.w400;
  static const FontWeight fontWeight500 = FontWeight.w500;
  static const FontWeight fontWeight600 = FontWeight.w600;
  static const FontWeight fontWeight700 = FontWeight.w700;

  // height
  static const height40 = 40;
  static const height20 = 20;
  static const height28 = 28;
  static const height24 = 24;
  static const height22 = 22;
  static const height16 = 16;
  static const height14 = 14;

  static TextStyle title1 = TextStyle(
    fontSize: fontSize32,
    fontFamily: fontFamily,
    fontWeight: fontWeight600,
    height: height40 / fontSize32,
    color: AppColors.neutral100,
  );

  static TextStyle title2 = TextStyle(
    fontSize: fontSize14,
    fontFamily: fontFamily,
    fontWeight: fontWeight400,
    height: height20 / fontSize14,
    color: AppColors.neutral100,
  );

  static TextStyle heading1 = TextStyle(
    fontSize: fontSize22,
    fontFamily: fontFamily,
    fontWeight: fontWeight600,
    height: height28 / fontSize22,
    color: AppColors.neutral100,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: fontSize18,
    fontFamily: fontFamily,
    fontWeight: fontWeight600,
    height: height24 / fontSize18,
    color: AppColors.neutral100,
  );

  static TextStyle heading3 = TextStyle(
    fontSize: fontSize16,
    fontFamily: fontFamily,
    fontWeight: fontWeight500,
    height: height22 / fontSize16,
    color: AppColors.neutral100,
  );

  static TextStyle body = TextStyle(
    fontSize: fontSize14,
    fontFamily: fontFamily,
    fontWeight: fontWeight400,
    height: height16 / fontSize14,
    color: AppColors.neutral100,
  );

  static TextStyle caption12 = TextStyle(
    fontSize: fontSize12,
    fontFamily: fontFamily,
    fontWeight: fontWeight400,
    height: height16 / fontSize12,
    color: AppColors.neutral100,
  );

  static TextStyle caption11 = TextStyle(
    fontSize: fontSize11,
    fontFamily: fontFamily,
    fontWeight: fontWeight400,
    height: height14 / fontSize11,
    color: AppColors.neutral100,
  );
}

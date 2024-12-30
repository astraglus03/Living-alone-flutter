import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required String imagePath,
    Color backgroundColor = GRAY400_COLOR,
    Duration duration = const Duration(seconds: 2),
    EdgeInsetsGeometry? margin,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: duration,
        padding: EdgeInsets.symmetric(horizontal: 12.0).r,
        shape: RoundedRectangleBorder(
          borderRadius:const BorderRadius.all(Radius.circular(12)).w ,
        ),
        behavior: SnackBarBehavior.floating,
        margin: margin ?? const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 60.0).r,
        elevation: 0,
        content: SizedBox(
          height: 48.h,
          child: Row(
            children: [
              SvgPicture.asset(imagePath),
              10.horizontalSpace,
              Text(
                message,
                style:AppTextStyles.body1.copyWith(color: WHITE100_COLOR),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

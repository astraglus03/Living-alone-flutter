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
    double? bottomOffset,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: GRAY500_COLOR,
        elevation: 0,
        content: Row(
          children: [
            SvgPicture.asset(
              imagePath,
            ),
            8.horizontalSpace,
            Text(
              message,
              style: AppTextStyles.body2.copyWith(
                color: WHITE100_COLOR,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: bottomOffset ?? 60.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

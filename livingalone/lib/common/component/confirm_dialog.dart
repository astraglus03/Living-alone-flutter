import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class ConfirmDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '종료하기',
    String cancelText = '취소',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            width: 300.w,
            height: 250.h,
            padding: EdgeInsets.all(24).w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                  // textAlign: TextAlign.center,
                ),
                12.verticalSpace,
                Text(
                  content,
                  style: AppTextStyles.body2.copyWith(color: GRAY600_COLOR),
                  // textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Column(
                  children: [
                    SizedBox(
                      width: 252.w,
                      height: 44.h,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          backgroundColor: BLUE400_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    SizedBox(
                      width: 252.w,
                      height: 44.h,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          backgroundColor: BLUE100_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: AppTextStyles.subtitle.copyWith(color: BLUE400_COLOR),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) ?? false;
  }
}
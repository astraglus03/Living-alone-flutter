import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomDoubleButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomDoubleButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WHITE100_COLOR,
        border: Border(
          top: BorderSide(
            color: GRAY200_COLOR,
            width: 1.w,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 10
            : 34.h,
        top: 12.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CommonButton(
                width: 168.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BLUE100_COLOR,
                      foregroundColor: BLUE400_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(8)).r
                      ),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text('이전', style: AppTextStyles.title),
                ),
              ),
              9.horizontalSpace,
              CommonButton(
                width: 168.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BLUE400_COLOR,
                    foregroundColor: WHITE100_COLOR,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)).r),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text('완료', style: AppTextStyles.title),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

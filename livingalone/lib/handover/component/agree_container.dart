import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';

class AgreeContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const AgreeContainer({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345.w,
        height: 56.h,
        padding: REdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? BLUE100_COLOR : GRAY100_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(12)).w,
          border: Border.all(
            color: isSelected ? BLUE400_COLOR : GRAY200_COLOR,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAgreeButton(
              isActive: isSelected,
              activeColor: BLUE400_COLOR,
              inactiveColor: GRAY400_COLOR,
            ),
            12.horizontalSpace,
            Text(text, style: AppTextStyles.subtitle),
          ],
        ),
      ),
    );
    ;
  }
}

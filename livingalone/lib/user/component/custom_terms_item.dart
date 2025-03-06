import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';

class CustomTermsItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onIconTap;
  final String title;
  final VoidCallback? onAgreeChanged;

   CustomTermsItem({
    required this.isSelected,
    required this.onIconTap,
    required this.title,
    this.onAgreeChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 56.h,
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? BLUE100_COLOR : GRAY100_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(12)).w,
        border: Border.all(
            color: isSelected ? BLUE200_COLOR : GRAY200_COLOR,
            width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onAgreeChanged,
            child: CustomAgreeButton(
              isActive: isSelected,
              activeColor: BLUE400_COLOR,
              inactiveColor: GRAY400_COLOR,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.subtitle,
            ),
          ),
          8.horizontalSpace,
          GestureDetector(
            onTap: onIconTap,
            child: Icon(
              Icons.keyboard_arrow_right,
              size: 24,
              color: GRAY300_COLOR,
            ),
          ),
        ],
      ),
    );
  }
} 
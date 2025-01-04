import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class ShowErrorText extends StatelessWidget {
  final String errorText;
  const ShowErrorText({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/image/warning.svg'),
        4.horizontalSpace,
        Text(errorText, style: AppTextStyles.caption2.copyWith(color: ERROR_TEXT_COLOR),),
      ],
    );
  }
}

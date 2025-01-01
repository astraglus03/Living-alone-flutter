import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonDivider extends StatelessWidget {
  const CommonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393.w,
      height: 8.h,
      decoration: const BoxDecoration(
        color: GRAY100_COLOR,
      ),
    );
  }
}

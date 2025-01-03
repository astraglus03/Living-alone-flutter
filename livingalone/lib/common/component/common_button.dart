import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const CommonButton({
    required this.child,
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 345.w,
      height: height ?? 50.h,
      child: child,
    );
  }
}

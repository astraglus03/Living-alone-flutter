import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/common/const/text_styles.dart';

class ComponentButton2 extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextInputType type;
  final VoidCallback? onTextFieldTap;
  final VoidCallback onPressed;
  final bool? obscureText;
  final Color? backgroundColor;
  final String? timerText;
  final bool showTimer;

  const ComponentButton2({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    required this.type,
    this.onTextFieldTap,
    required this.onPressed,
    this.obscureText,
    this.backgroundColor,
    this.timerText,
    this.showTimer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? WHITE100_COLOR,
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: TextFormField(
        controller: controller,
        scrollPadding: EdgeInsets.only(
          bottom: 50,
        ),
        onTap: onTextFieldTap,
        cursorColor: BLUE400_COLOR,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0).r,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (timerText != null && showTimer)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Text(
                    timerText!,
                    style: AppTextStyles.caption2.copyWith(
                      color: BLUE400_COLOR,
                    ),
                  ),
                ),
              IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  controller?.clear();
                  onPressed();
                  onChanged?.call('');
                },
                icon: SvgPicture.asset(
                  'assets/image/signupDelete.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
        ),
        keyboardType: type,
      ),
    );
  }
}

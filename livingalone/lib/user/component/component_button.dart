import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/common/const/text_styles.dart';

class ComponentButton extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextInputType type;
  final VoidCallback? onTextFieldTap;
  final VoidCallback onPressed;
  final bool? obscureText;
  final Color? formFieldBackground;
  final bool showTimer;
  final String? timerText;

  const ComponentButton({
    super.key,
    required this.controller,
    required this.hintText,
    required this.type,
    required this.onPressed,
    this.onChanged,
    this.onTextFieldTap,
    this.obscureText,
    this.formFieldBackground,
    this.showTimer = false,
    this.timerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: formFieldBackground ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: TextFormField(
        scrollPadding: EdgeInsets.only(bottom: 90),
        controller: controller,
        onTap: onTextFieldTap,
        cursorColor: BLUE400_COLOR,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0).r,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showTimer && timerText != null)
                Text(
                  timerText!,
                  style: AppTextStyles.caption2.copyWith(
                    color: BLUE400_COLOR,
                  ),
                ),
              IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: onPressed,
                icon: SvgPicture.asset('assets/image/signupDelete.svg',fit: BoxFit.cover,),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderSide: baseBorder,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: baseBorder,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: baseBorder,
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
        ),
        keyboardType: type,
      ),
    );
  }
}
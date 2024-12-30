import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final String? errorText;
  final controller;
  final Iterable<String>? autofillHint;
  // final TextInputAction? textInputAction;
  final VoidCallback? function;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;

   CustomInputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
    this.controller,
    this.autofillHint,
    // this.textInputAction,
    this.function,
    this.onChanged, this.width, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 345.w,
      height: height ?? 56.h,
      child: TextFormField(
        controller: controller,
        // 여기부분에도 암호가 생기도록 제작.
        autofillHints: autofillHint,
        // textInputAction: textInputAction,
        onEditingComplete: function,
        cursorColor: BLUE400_COLOR,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0).r,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: WHITE100_COLOR)),
          fillColor: WHITE100_COLOR,
          filled: true,
          hintText: hintText,
          hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
          errorText: errorText,
        ),
      ),
    );
  }
}

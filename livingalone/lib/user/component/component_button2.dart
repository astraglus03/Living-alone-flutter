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

  const ComponentButton2({
    super.key,
    this.controller,
    this.onChanged,
    required this.hintText,
    required this.type,
    this.onTextFieldTap,
    required this.onPressed,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: WHITE100_COLOR, // 흰색 배경
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: TextFormField(
        controller: controller,
        onTap: onTextFieldTap,
        cursorColor: BLUE400_COLOR,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0).r,
          suffixIcon: IconButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: onPressed,
            icon: SvgPicture.asset('assets/image/signupDelete.svg'),
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

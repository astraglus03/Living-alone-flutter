import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomInputField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const CustomInputField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BLUE400_COLOR)
          ),
          fillColor: WHITE100_COLOR,
          filled: true,
          hintText: hintText,
          hintStyle: AppTextStyles.subtitle.copyWith(color: BLUE400_COLOR),
        ),
      ),
    );
  }
}
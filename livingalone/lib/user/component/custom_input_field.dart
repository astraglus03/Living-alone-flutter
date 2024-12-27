import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345,
      height: 56,
      child: TextFormField(
        cursorColor: BLUE400_COLOR,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: BLUE400_COLOR)),
          fillColor: WHITE100_COLOR,
          filled: true,
          hintText: hintText,
          hintStyle: AppTextStyles.subtitle.copyWith(color: BLUE400_COLOR),
          errorText: errorText,
        ),
      ),
    );
  }
}

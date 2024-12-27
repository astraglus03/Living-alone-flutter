import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomSignupField extends StatelessWidget {
  final controller;
  final String hintText;
  final TextInputType type;
  final String validateText;
  final String subTitle;
  final String submitButtonTitle;
  final double width;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final VoidCallback? onTextFieldTap;
  final VoidCallback onPressed;
  final bool obscureText;
  final String? Function(String?)? validator;  // 추가된 부분


  const CustomSignupField({
    required this.controller,
    required this.hintText,
    required this.type,
    super.key,
    required this.validateText,
    required this.subTitle,
    required this.submitButtonTitle,
    this.width = 106, // FIXME: 피그마 기준 104인데 106으로 설정해야함.
    required this.onTap,
    this.focusNode,
    this.onTextFieldTap,
    required this.onPressed,
    this.obscureText = false, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345,
      // height: 148,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 345,
            child: TextFormField(
              controller: controller,
              onTap: onTextFieldTap,
              cursorColor: BLUE400_COLOR,
              obscureText: obscureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed:onPressed,
                  icon: Image.asset('assets/image/suffix_delete.png'),
                ),
                border: OutlineInputBorder(
                  borderSide: baseBorder,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: baseBorder),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: baseBorder,
                ),
                hintText: hintText,
                hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
              ),
              keyboardType: type,
              validator: validator
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: width,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BLUE100_COLOR,
                foregroundColor: BLUE400_COLOR,
                padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                shadowColor: Colors.transparent,
              ),
              onPressed: onTap,
              child: Text(submitButtonTitle,
              style: AppTextStyles.body1.copyWith(color: BLUE400_COLOR),
            ),),
          ),
        ],
      ),
    );
  }
}

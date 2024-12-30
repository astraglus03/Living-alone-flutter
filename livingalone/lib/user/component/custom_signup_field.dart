import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSignupField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType type;
  // final String validateText;
  final String subTitle;
  final String submitButtonTitle;
  final double width;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final VoidCallback? onTextFieldTap; // 키보드 화면 애니메이션을 위해 사용
  final VoidCallback onPressed;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomSignupField({
    this.controller,
    required this.hintText,
    required this.type,
    super.key,
    // required this.validateText,
    required this.subTitle,
    required this.submitButtonTitle,
    required this.width, // FIXME: 피그마 기준 104인데 106으로 설정해야함.
    required this.onTap,
    this.focusNode,
    this.onTextFieldTap,
    required this.onPressed,
    this.obscureText = false,
    this.validator, this.errorText, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345.w,
      // height: 148,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
          ),
          10.verticalSpace,
          SizedBox(
            width: 345.w,
            height: 56.h,
            child: TextFormField(
              controller: controller,
              onTap: onTextFieldTap,
              cursorColor: BLUE400_COLOR,
              obscureText: obscureText,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 16.0).r,
                suffixIcon: IconButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed:onPressed,
                  icon: SvgPicture.asset('assets/image/signupDelete.svg'),
                ),
                border: OutlineInputBorder(
                  borderSide: baseBorder,
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                    borderSide: baseBorder),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                  borderSide: baseBorder,
                ),
                hintText: hintText,
                hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
              ),
              keyboardType: type,
              validator: validator
            ),
          ),
          10.verticalSpace,
          if(errorText != null)
            Text(
                errorText!,
                style: AppTextStyles.caption2.copyWith(color: ERROR_TEXT_COLOR)
            ),
          10.verticalSpace,
          SizedBox(
            width: width.w,
            height: 32.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BLUE100_COLOR,
                foregroundColor: BLUE400_COLOR,
                padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0.r),
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

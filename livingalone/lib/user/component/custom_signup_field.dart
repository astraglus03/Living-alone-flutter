import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';

class CustomSignupField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType type;
  final String subTitle;
  final String? submitButtonTitle;
  final double width;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final VoidCallback? onTextFieldTap; // 키보드 화면 애니메이션을 위해 사용
  final VoidCallback onPressed;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Color? buttonBackground;
  final Color? buttonForeground;
  final Color? formFieldBackground;
  final bool? timer;
  final String? timerText;
  final Color?errorColor;
  final bool? errorImage;

  const CustomSignupField({
    this.controller,
    required this.hintText,
    required this.type,
    required this.subTitle,
    this.submitButtonTitle,
    required this.width, // FIXME: 피그마 기준 104인데 106으로 설정해야함.
    required this.onPressed,
    required this.onTap,
    this.focusNode,
    this.onTextFieldTap,
    this.obscureText = false,
    this.validator,
    this.errorText,
    this.onChanged,
    this.buttonBackground,
    this.formFieldBackground,
    this.timer,
    this.timerText,
    super.key, this.buttonForeground, this.errorColor = ERROR_TEXT_COLOR, this.errorImage = true,
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
          ComponentButton(
            controller: controller,
            onChanged: onChanged,
            hintText: hintText,
            type: type,
            onTextFieldTap: onTextFieldTap,
            onPressed: onPressed,
            obscureText: obscureText,
            formFieldBackground: formFieldBackground,
            showTimer: timer ?? false,
            timerText: timerText,
          ),
          10.verticalSpace,
          if (errorText != null)
            Column(
              children: [
                Row(
                  children: [
                    if (errorImage == true)
                      SvgPicture.asset('assets/image/warning.svg')
                    else
                      CustomAgreeButton(
                        isActive: true,
                        activeColor: BLUE400_COLOR,
                        isSmall: true,
                      ),
                    4.horizontalSpace,
                    Text(errorText!,
                        style: AppTextStyles.caption2
                            .copyWith(color: errorColor ?? ERROR_TEXT_COLOR)),
                  ],
                ),
                10.verticalSpace,
              ],
            ),
          if(submitButtonTitle !=null)
          SizedBox(
            width: width.w,
            height: 32.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackground ?? BLUE100_COLOR,
                foregroundColor: buttonForeground ?? BLUE400_COLOR,
                padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 4.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0.r),
                ),
                shadowColor: Colors.transparent,
                disabledBackgroundColor: GRAY100_COLOR,
                disabledForegroundColor: GRAY400_COLOR,
              ),
              onPressed: onTap,
              child: Text(
                submitButtonTitle!,
                style: AppTextStyles.body1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

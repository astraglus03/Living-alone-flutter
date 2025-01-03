import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';

class CustomBottomButton2 extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  const CustomBottomButton2({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.textStyle,
    required this.onTap,
    this.isEnabled = true,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).viewInsets.bottom + 34,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: GRAY200_COLOR,
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CommonButton(
              child: ElevatedButton(
                onPressed: isEnabled ? onTap : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return disabledBackgroundColor ?? backgroundColor;
                    }
                    return backgroundColor;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return disabledForegroundColor ?? foregroundColor;
                    }
                    return foregroundColor;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  animationDuration: Duration.zero
                ),
                child: Text(
                  text,
                  style: textStyle.copyWith(
                    color: isEnabled ? foregroundColor : disabledForegroundColor
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

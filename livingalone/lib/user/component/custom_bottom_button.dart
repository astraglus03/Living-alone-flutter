import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';

class CustomBottomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final bool? appbarBorder;

  const CustomBottomButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.textStyle,
    required this.onTap,
    this.isEnabled = true,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.appbarBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final targetPadding = bottomInset > 0 ? bottomInset + 10 : 34.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: bottomInset > 0 ? 34 : targetPadding,
        end: targetPadding,
      ),
      duration: Duration(milliseconds: bottomInset > 0 ? 100 : 300),
      // 올라갈 때 100ms, 내려올 때 300ms
      curve: bottomInset > 0 ? Curves.easeOut : Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          decoration: appbarBorder == true
              ? BoxDecoration(
                  color: WHITE100_COLOR,
                  border: Border(
                    top: BorderSide(
                      color: GRAY200_COLOR,
                      width: 1.w,
                    ),
                  ),
                )
              : null,
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            bottom: value,
            top: 12.h,
          ),
          child: CommonButton(
            child: ElevatedButton(
              onPressed: isEnabled ? onTap : null,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return disabledBackgroundColor ?? backgroundColor;
                  }
                  return backgroundColor;
                }),
                foregroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
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
                animationDuration: Duration.zero,
              ),
              child: Text(
                text,
                style: textStyle.copyWith(
                  color: isEnabled ? foregroundColor : disabledForegroundColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

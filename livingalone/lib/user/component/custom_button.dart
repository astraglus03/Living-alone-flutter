import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.textStyle,
    required this.onTap,
    this.isEnabled = true, this.disabledBackgroundColor, this.disabledForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 34,
      left: 24,
      child: CommonButton(
        child: ElevatedButton(
          onPressed: isEnabled ? onTap : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? backgroundColor : disabledBackgroundColor,
              foregroundColor: isEnabled ? foregroundColor : disabledForegroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            shadowColor: Colors.transparent,
          ),
          // TODO: 자체 material때문에 반응이 느린것처럼 보임. 아래는 애니메이션 없음.
          // style: ButtonStyle(
          //   backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          //     if (states.contains(MaterialState.disabled)) {
          //       return disabledBackgroundColor ?? backgroundColor;
          //     }
          //     return backgroundColor;
          //   }),
          //   foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          //     if (states.contains(MaterialState.disabled)) {
          //       return disabledForegroundColor ?? foregroundColor;
          //     }
          //     return foregroundColor;
          //   }),
          //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //     RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //   ),
          //   shadowColor: MaterialStateProperty.all(Colors.transparent),
          //   animationDuration: Duration.zero,
          // ),
          child: Text(
            text,
            style: textStyle.copyWith(color: isEnabled ? foregroundColor : disabledForegroundColor),
          ),
        ),
      ),
    );
  }
}

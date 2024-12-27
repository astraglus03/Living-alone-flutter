import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class FindSignupButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const FindSignupButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 36,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: WHITE100_COLOR,
            foregroundColor: BLUE400_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.caption2,
          )),
    );
  }
}

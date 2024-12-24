import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.textStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 24,
      child: SizedBox(
        width: 345,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              )),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

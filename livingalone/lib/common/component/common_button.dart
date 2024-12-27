import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Widget child;

  const CommonButton({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345,
      height: 50,
      child: child,
    );
  }
}

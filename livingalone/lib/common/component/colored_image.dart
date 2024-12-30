import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColoredIcon extends StatelessWidget {
  final String imagePath;
  final bool isActive;

  const ColoredIcon({
    super.key,
    required this.imagePath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      colorFilter: ColorFilter.mode(
        isActive ? BLUE400_COLOR : GRAY400_COLOR,
        BlendMode.srcIn,
      ),
    );
  }
}
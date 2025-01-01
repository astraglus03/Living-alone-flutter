import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/common/const/colors.dart';

class ColoredImageFill extends StatelessWidget {
  final bool isActive;

  const ColoredImageFill({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      isActive ? 'assets/image/like_full.svg' : 'assets/image/like_border.svg',
      colorFilter: ColorFilter.mode(
        BLUE400_COLOR,
        BlendMode.srcIn,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RootTabColoredImage extends StatelessWidget {
  final String imagePath;
  final bool isActive;

  const RootTabColoredImage({
    super.key,
    required this.imagePath,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      colorFilter: ColorFilter.mode(
        isActive ? GRAY800_COLOR : GRAY400_COLOR,
        BlendMode.srcIn,
      ),
    );
  }
}
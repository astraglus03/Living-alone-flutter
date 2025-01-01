import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoDetailCard extends StatelessWidget {
  final String title;
  final String introText;

  const InfoDetailCard({
    required this.title,
    required this.introText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           title,
            style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
          14.verticalSpace,
          Text(introText, style: AppTextStyles.body2.copyWith(color: GRAY700_COLOR),)
        ],
      ),
    );
  }
}

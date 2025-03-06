import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformCommonInquiry extends StatelessWidget {
  const InformCommonInquiry({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: BLUE100_COLOR,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '잘못된 정보로 커뮤니티를 이용할 경우, 관리자가 조치를 취할 수 있습니다. 커뮤니티가 더욱 신뢰할 수 있는 공간이 될 수 있도록 협조 부탁드립니다.',
        style: AppTextStyles.body1.copyWith(
          color: GRAY800_COLOR,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

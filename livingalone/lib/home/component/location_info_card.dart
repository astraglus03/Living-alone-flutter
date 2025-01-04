import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationInfoCard extends StatelessWidget {
  final String address;

  const LocationInfoCard({
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '위치',
            style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
          16.verticalSpace,
          Container(
            width: MediaQuery.of(context).size.width - 48.w,
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: GRAY200_COLOR,
                width: 1,
              ),
            ),
            // TODO: 실제 지도 구현 필요
            child: Center(
              child: Text(
                '지도가 표시될 영역',
                style: AppTextStyles.body2.copyWith(
                  color: GRAY400_COLOR,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
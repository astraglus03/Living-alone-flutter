import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FacilitiesCard extends StatelessWidget {
  final List<String> facilities;

  const FacilitiesCard({
    required this.facilities,
    super.key,
  });

  String _getAssetName(String facility) {
    final Map<String, String> assetMap = {
      '편의점': 'convenience',
      '마트': 'mart',
      '카페': 'cafe',
      '병원': 'hospital',
      '약국': 'pharmacy',
      '대중교통': 'transportation',
    };
    return assetMap[facility] ?? 'default';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주변 편의시설',
            style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
          Text(
            '걸어서 10분 이내에 이용 가능한 편의시설입니다.',
            style: AppTextStyles.body2.copyWith(color: GRAY600_COLOR),
          ),
          16.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: facilities.map((facility) => 
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: WHITE100_COLOR,
                  borderRadius: BorderRadius.circular(4).r,
                  border: Border.all(
                    color: GRAY100_COLOR,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/image/${_getAssetName(facility)}.svg',
                      width: 14.w,
                      height: 14.h,
                    ),
                    4.horizontalSpace,
                    Text(
                      facility,
                      style: AppTextStyles.body2.copyWith(
                        color: GRAY800_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
} 
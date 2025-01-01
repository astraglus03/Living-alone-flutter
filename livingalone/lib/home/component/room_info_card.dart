import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomInfoCard extends StatelessWidget {
  final String buildingType;    // 건물유형
  final String propertyType;    // 매물종류
  final String rentType;        // 임대방식
  final String area;           // 면적
  final String floor;          // 층
  final List<String> options;   // 옵션
  final List<String> facilities; // 시설
  final List<String> conditions; // 조건
  final String availableDate;   // 입주가능일

  const RoomInfoCard({
    required this.buildingType,
    required this.propertyType,
    required this.rentType,
    required this.area,
    required this.floor,
    required this.options,
    required this.facilities,
    required this.conditions,
    required this.availableDate,
    super.key,
  });

  Widget _buildInfoRow(String label, String value) {
    return Container(
      width: 345.w,
      height: 48.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: GRAY200_COLOR,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: GRAY800_COLOR,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body2.copyWith(
                color: GRAY700_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String label, List<String> items) {
    return Container(
      width: 345.w,
      height: 47.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: GRAY200_COLOR,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 100.w,
              child: Text(
                label,
                style: AppTextStyles.body1.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
            ),
            Expanded(
              child: Text(
                items.join(', '),
                style: AppTextStyles.body2.copyWith(
                  color: GRAY700_COLOR,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '방 정보',
            style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
          16.verticalSpace,
          _buildInfoRow('건물유형', buildingType),
          _buildInfoRow('매물종류', propertyType),
          _buildInfoRow('임대방식', rentType),
          _buildInfoRow('면적', area),
          _buildInfoRow('층', floor),
          _buildListRow('옵션', options),
          _buildListRow('시설', facilities),
          _buildListRow('조건', conditions),
          _buildInfoRow('입주가능일', availableDate),
        ],
      ),
    );
  }
} 
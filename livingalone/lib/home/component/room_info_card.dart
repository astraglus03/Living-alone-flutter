import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoomInfoCard extends StatelessWidget {
  final String buildingType;    // 건물유형
  final String propertyType;    // 매물종류
  final String rentType;        // 임대방식
  final String area;           // 면적
  final String floor;          // 층
  final List<String> options;   // 옵션
  final List<String> facilities; // 시설
  final List<String> conditions; // 조건
  final DateTime availableDate;   // 입주가능일

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

  Widget _buildInfoRow(String label, dynamic value,  {bool isImmediateAvailable = false}) {
    String displayValue = '';

    if (value is DateTime) {
      displayValue = '${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}~';
    } else {
      displayValue = value.toString();
    }

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
            child: Row(
              children: [
                if (isImmediateAvailable)
                  Container(
                    margin: EdgeInsets.only(right: 9.w),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: BLUE100_COLOR,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '즉시입주가능',
                      style: AppTextStyles.caption2.copyWith(
                        color: BLUE400_COLOR,
                      ),
                    ),
                  ),
                Text(
                  displayValue,
                  style: AppTextStyles.body2.copyWith(
                    color: GRAY700_COLOR,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRowWithIcons(String label, List<String> items, bool showIcons) {
    final Map<String, String> iconPaths = {
      '엘리베이터': 'assets/icons/elevator.svg',
      '주차장': 'assets/icons/parking.svg',
      'CCTV': 'assets/icons/cctv.svg',
      '복층': 'assets/icons/duplex.svg',
      '즉시입주 가능': 'assets/icons/home.svg',
      '반려동물 가능': 'assets/icons/pet.svg',
    };

    return Container(
      width: 345.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: label == '옵션' 
                ? Text(
                    items.join(', '),
                    style: AppTextStyles.body2.copyWith(
                      color: GRAY700_COLOR,
                    ),
                  )
                : Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: items.map((item) {
                      if (!showIcons || !iconPaths.containsKey(item)) {
                        return Text(
                          item,
                          style: AppTextStyles.body2.copyWith(
                            color: GRAY700_COLOR,
                          ),
                        );
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: BLUE100_COLOR,
                              borderRadius: BorderRadius.all(Radius.circular(20)).r,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                iconPaths[item]!,
                                width: 14.w,
                                height: 14.h,
                                color: BLUE400_COLOR,
                              ),
                            ),
                          ),
                          6.horizontalSpace,
                          Text(
                            item,
                            style: AppTextStyles.body2.copyWith(
                              color: GRAY700_COLOR,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
          _buildListRowWithIcons('옵션', options, false),
          _buildListRowWithIcons('시설', facilities, true),
          _buildListRowWithIcons('조건', conditions, true),
          _buildInfoRow('입주 가능일', availableDate, isImmediateAvailable: true)
        ],
      ),
    );
  }
} 
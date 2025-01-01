import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketInfoCard extends StatelessWidget {
  final String ticketType;      // 이용권 유형
  final String remainingCount;  // 남은 횟수
  final String transferFee;     // 양도 수수료
  final String availableDate;   // 이용가능일

  const TicketInfoCard({
    required this.ticketType,
    required this.remainingCount,
    required this.transferFee,
    required this.availableDate,
    super.key,
  });

  Widget _buildInfoRow(String label, String value) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이용권 정보',
            style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
          16.verticalSpace,
          _buildInfoRow('이용권 유형', ticketType),
          _buildInfoRow('남은 횟수', remainingCount),
          _buildInfoRow('양도 수수료', transferFee),
          _buildInfoRow('이용가능일', availableDate),
        ],
      ),
    );
  }
} 
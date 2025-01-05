import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/enum/use_type.dart';
import 'package:ticket_clippers/ticket_clippers.dart';
import 'package:dotted_line/dotted_line.dart';

class RentUseCard extends StatelessWidget {
  final UseType useType;
  final int leftTime;
  final int maintenance; // 양도비
  final int? monthlyRent; // 월세 (월세일 때만 사용)

  const RentUseCard({
    required this.useType,
    required this.leftTime,
    required this.maintenance,
    this.monthlyRent,
    super.key,
  });

  String _formatPrice(int value) {
    if (value >= 10000) {
      int billionUnit = value ~/ 10000;  // 억 단위
      int tenThousandUnit = value % 10000;  // 만 단위
      if (tenThousandUnit > 0) {
        return '$billionUnit억 $tenThousandUnit만원';
      }
      return '$billionUnit억원';
    } else {
      return '$value만원';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (useType == RentType.monthlyRent) {
      // 월세인 경우 3개의 항목 표시
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 보증금
          _buildTicketSection(
            width: 115.w,
            label: '보증금',
            value: leftTime,
            isFirst: true,
          ),
          // 월세
          _buildTicketSection(
            width: 115.w,
            label: '월세',
            value: monthlyRent!,
          ),
          // 관리비
          _buildTicketSection(
            width: 115.w,
            label: '관리비',
            value: maintenance,
            isLast: true,
          ),
        ],
      );
    } else {
      // 전세나 단기임대인 경우 2개의 항목 표시
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTicketSection(
            width: 172.w,
            label: useType == RentType.wholeRent ? '보증금' : '월세',
            value: leftTime,
            isFirst: true,
          ),
          _buildTicketSection(
            width: 173.w,
            label: '관리비',
            value: maintenance,
            isLast: true,
          ),
        ],
      );
    }
  }

  Widget _buildTicketSection({
    required double width,
    required String label,
    required int value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    // 첫번째나 마지막이 아닌 경우 (가운데 섹션)
    if (!isFirst && !isLast) {
      return Container(
        width: width,
        height: 80.h,
        decoration: BoxDecoration(
          color: BLUE100_COLOR,
        ),
        child: Row(
          children: [
            const DottedLine(
              direction: Axis.vertical,
              lineLength: 45,
              dashLength: 2.5,
              dashColor: BLUE300_COLOR,
              lineThickness: 2,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                  ),
                  4.verticalSpace,
                  Text(
                    _formatPrice(value),
                    style: AppTextStyles.subtitle.copyWith(color: BLUE400_COLOR),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 첫번째나 마지막인 경우
    return ClipPath(
      clipper: TicketRoundedEdgeClipper(
        edge: isFirst ? Edge.left : Edge.right,
        position: 45,
        radius: 20,
      ),
      child: Container(
        width: width,
        height: 80.h,
        decoration: BoxDecoration(
          color: BLUE100_COLOR,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? Radius.circular(12).r : Radius.zero,
            right: isLast ? Radius.circular(12).r : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            if (!isFirst)
              const DottedLine(
                direction: Axis.vertical,
                lineLength: 45,
                dashLength: 2.5,
                dashColor: BLUE300_COLOR,
                lineThickness: 2,
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                  ),
                  4.verticalSpace,
                  Text(
                    _formatPrice(value),
                    style: AppTextStyles.subtitle.copyWith(
                        color: BLUE400_COLOR,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
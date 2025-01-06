import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:ticket_clippers/ticket_clippers.dart';

class RentUseCard extends StatelessWidget {
  final int? remainingCount;    // 남은 횟수
  final int? remainingTime;     // 남은 시간 (시간 단위)
  final DateTime? expiredDate;  // 만료일
  final int price;             // 양도비

  const RentUseCard({
    this.remainingCount,
    this.remainingTime,
    this.expiredDate,
    required this.price,
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

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // 제한 조건들을 리스트로 만들기
    final List<Map<String, String>> sections = [];

    // 횟수 제한이 있는 경우
    if (remainingCount != null) {
      sections.add({
        'label': '남은 횟수',
        'value': '$remainingCount회',
      });
    }

    // 시간 제한이 있는 경우
    if (remainingTime != null) {
      sections.add({
        'label': '남은 시간',
        'value': '$remainingTime시간',
      });
    }

    // 기간 제한이 있는 경우
    if (expiredDate != null) {
      sections.add({
        'label': '만료일',
        'value': _formatDate(expiredDate!),
      });
    }

    // 양도비는 항상 마지막에 추가
    sections.add({
      'label': '양도비',
      'value': _formatPrice(price),
    });

    // 섹션 수에 따른 너비 계산
    final sectionWidth = (345.w) / sections.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.map((entry) {
        final index = entry.key;
        final section = entry.value;

        return _buildTicketSection(
          width: sectionWidth,
          label: section['label']!,
          value: section['value']!,
          isFirst: index == 0,
          isLast: index == sections.length - 1,
        );
      }).toList(),
    );
  }

  Widget _buildTicketSection({
    required double width,
    required String label,
    required String value,
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
                    value,
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
                    value,
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
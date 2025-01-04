import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class StatItem extends StatelessWidget {
  final String label; // 댓글, 채팅, 관심
  final int value; // 값

  const StatItem({
    super.key,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w500, color: GRAY500_COLOR ),
        children: [
          TextSpan(
            text: ' $value',
            style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w800, color: BLUE400_COLOR),
          ),
        ],
      ),
    );
  }
}

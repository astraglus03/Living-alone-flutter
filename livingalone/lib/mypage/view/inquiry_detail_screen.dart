import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:intl/intl.dart';
import 'package:livingalone/mypage/models/inquiry_model.dart';

class InquiryDetailScreen extends ConsumerWidget {
  final InquiryModel inquiry;

  const InquiryDetailScreen({
    required this.inquiry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '문의내역',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInquirySection(),
            if (inquiry.answer != null) ...[
              Divider(
                height: 1.h,
                color: GRAY100_COLOR,
              ),
              _buildAnswerSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInquirySection() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${inquiry.category} | ${DateFormat('yyyy.MM.dd').format(inquiry.createdAt)}',
            style: AppTextStyles.caption2.copyWith(
              color: GRAY400_COLOR,
            ),
          ),
          2.verticalSpace,
          Text(
            inquiry.title,
            style: AppTextStyles.subtitle.copyWith(
              color: GRAY800_COLOR,
            ),
          ),
          12.verticalSpace,
          Text(
            inquiry.content,
            style: AppTextStyles.body1.copyWith(
                color: GRAY700_COLOR,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection() {
    if (inquiry.answer == null || inquiry.answeredAt == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '답변 | ${DateFormat('yyyy.MM.dd').format(inquiry.answeredAt!)}',
            style: AppTextStyles.caption2.copyWith(
              color: GRAY400_COLOR,
            ),
          ),
          16.verticalSpace,
          Text(
            inquiry.answer!,
            style: AppTextStyles.body1.copyWith(
              color: GRAY700_COLOR,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
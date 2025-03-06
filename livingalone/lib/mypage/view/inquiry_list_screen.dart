import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view_models/inquiry_provider.dart';
import 'package:livingalone/mypage/view/inquiry_detail_screen.dart';
import 'package:intl/intl.dart';

class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inquiryProvider);

    if (state.isLoading) {
      return DefaultLayout(
        title: '문의내역',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return DefaultLayout(
        title: '문의내역',
        child: Center(
          child: Text(state.error!),
        ),
      );
    }

    if (state.inquiries.isEmpty) {
      return DefaultLayout(
        title: '문의내역',
        child: _buildEmptyState(),
      );
    }

    return DefaultLayout(
      title: '문의내역',
      child: ListView.separated(
        itemCount: state.inquiries.length,
        separatorBuilder: (context, index) => Divider(
          height: 1.h,
          thickness: 1.h,
          color: GRAY200_COLOR,
        ),
        itemBuilder: (context, index) {
          final inquiry = state.inquiries[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InquiryDetailScreen(inquiry: inquiry),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: inquiry.answer != null
                              ? BLUE100_COLOR
                              : GRAY100_COLOR,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          inquiry.answer != null ? '답변완료' : '답변대기',
                          style: AppTextStyles.caption2.copyWith(
                            color: inquiry.answer != null
                                ? BLUE400_COLOR
                                : GRAY600_COLOR,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy.MM.dd').format(inquiry.createdAt),
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY500_COLOR,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    inquiry.title,
                    style: AppTextStyles.body1.copyWith(
                      color: GRAY800_COLOR,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    inquiry.content,
                    style: AppTextStyles.body2.copyWith(
                      color: GRAY600_COLOR,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: GRAY100_COLOR,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.question_answer_outlined,
              color: GRAY400_COLOR,
              size: 32.w,
            ),
          ),
          16.verticalSpace,
          Text(
            '문의 내역이 없습니다.',
            style: AppTextStyles.body1.copyWith(
              color: GRAY400_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
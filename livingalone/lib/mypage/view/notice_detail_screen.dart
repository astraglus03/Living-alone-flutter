import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view_models/notice_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeDetailScreen extends ConsumerWidget {
  final String noticeId;

  const NoticeDetailScreen({
    required this.noticeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeState = ref.watch(noticeDetailProvider(noticeId));

    return DefaultLayout(
      title: '공지사항',
      child: noticeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
        data: (notice) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  style: AppTextStyles.title.copyWith(
                    color: GRAY800_COLOR,
                  ),
                ),
                8.verticalSpace,
                Text(
                  DateFormat('yyyy.MM.dd').format(notice.createdAt),
                  style: AppTextStyles.caption2.copyWith(
                    color: GRAY500_COLOR,
                  ),
                ),
                24.verticalSpace,
                Text(
                  notice.content,
                  style: AppTextStyles.body2.copyWith(
                    color: GRAY700_COLOR,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
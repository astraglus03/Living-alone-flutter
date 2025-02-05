// lib/mypage/view/notice_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view/notice_detail_screen.dart';
import 'package:livingalone/mypage/view_models/notice_provider.dart';
import 'package:intl/intl.dart';

class NoticeListScreen extends ConsumerWidget {
  const NoticeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noticeProvider);

    if (state.isLoading) {
      return DefaultLayout(
        title: '공지사항',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return DefaultLayout(
        title: '공지사항',
        child: Center(
          child: Text(state.error!),
        ),
      );
    }

    return DefaultLayout(
      title: '공지사항',
      child: ListView.separated(
        itemCount: state.notices.length,
        separatorBuilder: (context, index) => Divider(
          height: 1.h,
          thickness: 1.h,
          color: GRAY200_COLOR,
        ),
        itemBuilder: (context, index) {
          final notice = state.notices[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeDetailScreen(noticeId: notice.id),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: AppTextStyles.body1.copyWith(
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
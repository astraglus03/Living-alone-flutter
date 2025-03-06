import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/view/language_detail_screen.dart';
import 'package:livingalone/mypage/view_models/mypage_provider.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userMeProvider);

    if (userState is UserModelLoading) {
      return DefaultLayout(
        title: '언어 설정',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userState is UserModelError) {
      return DefaultLayout(
        title: '언어 설정',
        child: Center(
          child: Text('설정을 불러올 수 없습니다: ${userState.message}'),
        ),
      );
    }

    final state = userState as UserModel;

    return DefaultLayout(
      title: '언어 설정',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '언어',
                style: AppTextStyles.subtitle.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
              trailing: Text(
                state.language!,
                style: AppTextStyles.body2.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LanguageDetailScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

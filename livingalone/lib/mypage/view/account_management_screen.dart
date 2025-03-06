import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view/change_password_screen.dart';
import 'package:livingalone/mypage/view_models/mypage_provider.dart';

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPageProvider);

    return DefaultLayout(
      title: '계정 관리',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            _buildInfoItem(
              label: '이메일',
              value: state.profile!.email,
              isEditable: false,
            ),
            _buildInfoItem(
              label: '휴대폰 번호',
              value: state.profile!.phoneNumber,
              isEditable: false,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChangePasswordScreen(),
                  ),
                );
              },
              child: _buildInfoItem(
                label: '비밀번호 변경',
                showArrow: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    String? value,
    bool isEditable = true,
    bool showArrow = false,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 56.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.subtitle.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
              Row(
                children: [
                  if (value != null)
                    Text(
                      value,
                      style: AppTextStyles.body2.copyWith(
                        color: GRAY600_COLOR,
                      ),
                    ),
                  if (showArrow) ...[
                    8.horizontalSpace,
                    Icon(
                      Icons.arrow_forward_ios,
                      color: GRAY400_COLOR,
                      size: 16.w,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: GRAY200_COLOR),
      ],
    );
  }
}
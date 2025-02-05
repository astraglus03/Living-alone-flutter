import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/enum/notification_settings.dart';
import 'package:livingalone/mypage/view_models/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return DefaultLayout(
      title: '알림 설정',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            20.verticalSpace,
            ...NotificationType.values.map((type) => _buildNotificationItem(
              context: context,
              type: type,
              isEnabled: settings[type]!,
              onChanged: (value) {
                ref.read(notificationSettingsProvider.notifier).toggleNotification(type);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required NotificationType type,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          decoration: BoxDecoration(
            color: GRAY100_COLOR,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: AppTextStyles.body1.copyWith(
                        color: isEnabled ? GRAY800_COLOR : GRAY500_COLOR,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      type.description,
                      style: AppTextStyles.caption2.copyWith(
                        color: isEnabled ? GRAY600_COLOR : GRAY400_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoSwitch(
                value: isEnabled,
                onChanged: onChanged,
                activeColor: BLUE400_COLOR,
              )
                  : Switch(
                value: isEnabled,
                onChanged: onChanged,
                activeColor: BLUE400_COLOR,
                trackColor: MaterialStateProperty.resolveWith(
                      (states) => states.contains(MaterialState.selected)
                      ? BLUE100_COLOR
                      : GRAY200_COLOR,
                ),
              ),
            ],
          ),
        ),
        8.verticalSpace,
      ],
    );
  }
}
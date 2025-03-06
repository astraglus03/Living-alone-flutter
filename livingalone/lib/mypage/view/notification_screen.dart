import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/enum/notification_settings.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

class NotificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userMeProvider);

    if (profile is UserModelLoading) {
      return const DefaultLayout(
        title: '알림 설정',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profile is UserModelError) {
      return DefaultLayout(
        title: '알림 설정',
        child: Center(
          child: Text('내정보를 불러올 수 없습니다: ${profile.message}'),
        ),
      );
    }

    final user = profile as UserModel;

    return DefaultLayout(
      title: '알림 설정',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            20.verticalSpace,
            _buildNotificationItem(
              context: context,
              type: NotificationType.all,
              isEnabled: user.serviceAlarm,
              onChanged: (value) {
                // ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.all);
                ref.read(userMeProvider.notifier).updateNotificationSettings(alarm: !user.serviceAlarm);
              },
            ),
            // _buildNotificationItem(
            //   context: context,
            //   type: NotificationType.chat,
            //   isEnabled: profile.chatNotificationEnabled,
            //   onChanged: (value) {
            //     ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.chat);
            //   },
            // ),
            // _buildNotificationItem(
            //   context: context,
            //   type: NotificationType.neighborhoodPost,
            //   isEnabled: profile.neighborNotificationEnabled,
            //   onChanged: (value) {
            //     ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.neighborhoodPost);
            //   },
            // ),
            // _buildNotificationItem(
            //   context: context,
            //   type: NotificationType.comment,
            //   isEnabled: profile.handoverNotificationEnabled,
            //   onChanged: (value) {
            //     ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.comment);
            //   },
            // ),
            // _buildNotificationItem(
            //   context: context,
            //   type: NotificationType.community,
            //   isEnabled: profile.communityNotificationEnabled,
            //   onChanged: (value) {
            //     ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.community);
            //   },
            // ),
            // _buildNotificationItem(
            //   context: context,
            //   type: NotificationType.official,
            //   isEnabled: profile.noticeNotificationEnabled,
            //   onChanged: (value) {
            //     ref.read(notificationSettingsProvider.notifier).toggleNotification(NotificationType.official);
            //   },
            // ),
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
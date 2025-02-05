import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/enum/notification_settings.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, Map<NotificationType, bool>>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettingsNotifier extends StateNotifier<Map<NotificationType, bool>> {
  NotificationSettingsNotifier() : super({
    NotificationType.all: true,
    NotificationType.chat: true,
    NotificationType.comment: true,
    NotificationType.neighborhoodPost: true,
    NotificationType.community: true,
    NotificationType.official: true,
  });

  void toggleNotification(NotificationType type) {
    if (type == NotificationType.all) {
      final newValue = !state[NotificationType.all]!;
      state = {
        for (var type in NotificationType.values)
          type: newValue
      };
    } else {
      state = {
        ...state,
        type: !state[type]!,
        // 모든 개별 알림이 꺼지면 전체 알림도 꺼짐
        NotificationType.all: state[NotificationType.all]! && type != NotificationType.all
      };
    }
    _updateNotificationSettings();
  }

  Future<void> _updateNotificationSettings() async {
    // TODO: SharedPreferences에 저장
    // TODO: 서버에 알림 설정 업데이트
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/enum/notification_settings.dart';
import 'package:livingalone/mypage/models/user_profile_model.dart';
import 'package:livingalone/mypage/repository/mypage_repository.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, UserProfileModel>((ref) {
  final repository = ref.watch(myPageRepositoryProvider);
  return NotificationSettingsNotifier(repository);
});

class NotificationSettingsNotifier extends StateNotifier<UserProfileModel> {
  final MyPageRepository _repository;

  NotificationSettingsNotifier(this._repository) : super(UserProfileModel(
    id: '',
    email: '',
    nickname: '',
    phoneNumber: '',
    language: 'ko',
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = await _repository.getProfile();
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  void toggleNotification(NotificationType type) {
    switch (type) {
      case NotificationType.all:
        final newValue = !state.pushNotificationEnabled;
        state = state.copyWith(
          pushNotificationEnabled: newValue,
          chatNotificationEnabled: newValue,
          neighborNotificationEnabled: newValue,
          handoverNotificationEnabled: newValue,
          communityNotificationEnabled: newValue,
          noticeNotificationEnabled: newValue,
        );
        break;
      case NotificationType.chat:
        state = state.copyWith(
          chatNotificationEnabled: !state.chatNotificationEnabled,
          pushNotificationEnabled: _shouldEnableAllNotifications(type),
        );
        break;
      case NotificationType.neighborhoodPost:
        state = state.copyWith(
          neighborNotificationEnabled: !state.neighborNotificationEnabled,
          pushNotificationEnabled: _shouldEnableAllNotifications(type),
        );
        break;
      case NotificationType.comment:
        state = state.copyWith(
          handoverNotificationEnabled: !state.handoverNotificationEnabled,
          pushNotificationEnabled: _shouldEnableAllNotifications(type),
        );
        break;
      case NotificationType.community:
        state = state.copyWith(
          communityNotificationEnabled: !state.communityNotificationEnabled,
          pushNotificationEnabled: _shouldEnableAllNotifications(type),
        );
        break;
      case NotificationType.official:
        state = state.copyWith(
          noticeNotificationEnabled: !state.noticeNotificationEnabled,
          pushNotificationEnabled: _shouldEnableAllNotifications(type),
        );
        break;
    }
    _updateNotificationSettings();
  }

  bool _shouldEnableAllNotifications(NotificationType excludedType) {
    return state.chatNotificationEnabled &&
           state.neighborNotificationEnabled &&
           state.handoverNotificationEnabled &&
           state.communityNotificationEnabled &&
           state.noticeNotificationEnabled;
  }

  Future<void> _updateNotificationSettings() async {
    try {
      final updatedProfile = await _repository.updateNotificationSettings(
        body: {
          'pushNotificationEnabled': state.pushNotificationEnabled,
          'chatNotificationEnabled': state.chatNotificationEnabled,
          'neighborNotificationEnabled': state.neighborNotificationEnabled,
          'handoverNotificationEnabled': state.handoverNotificationEnabled,
          'communityNotificationEnabled': state.communityNotificationEnabled,
          'noticeNotificationEnabled': state.noticeNotificationEnabled,
        },
      );
      state = updatedProfile;
    } catch (e) {
      // TODO: 에러 처리
      print('Failed to update notification settings: $e');
      // 실패 시 이전 상태로 롤백
      _loadSettings();
    }
  }
}
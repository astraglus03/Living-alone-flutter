// lib/mypage/view_models/change_password_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changePasswordProvider =
StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
  return ChangePasswordNotifier();
});

class ChangePasswordState {
  final bool isLoading;
  final String? error;

  ChangePasswordState({
    this.isLoading = false,
    this.error,
  });

  ChangePasswordState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  ChangePasswordNotifier() : super(ChangePasswordState());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: API 연동
      await Future.delayed(Duration(seconds: 2)); // 임시 딜레이

      state = state.copyWith(isLoading: false);
      // TODO: 성공 처리 (예: 스낵바 표시)
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      // TODO: 에러 처리 (예: 스낵바 표시)
    }
  }
}
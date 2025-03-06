// lib/mypage/view_models/notice_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/notice_model.dart';
import 'package:livingalone/mypage/repository/notice_repository.dart';

final noticeProvider = StateNotifierProvider<NoticeNotifier, NoticeState>((ref) {
  // final repository = ref.watch(noticeRepositoryProvider);  // API 연동 시 사용
  final repository = DummyNoticeRepository();  // 더미 데이터 사용
  return NoticeNotifier(repository);
});

class NoticeState {
  final List<NoticeModel> notices;
  final NoticeModel? currentNotice;
  final bool isLoading;
  final String? error;

  NoticeState({
    this.notices = const [],
    this.currentNotice,
    this.isLoading = false,
    this.error,
  });

  NoticeState copyWith({
    List<NoticeModel>? notices,
    NoticeModel? currentNotice,
    bool? isLoading,
    String? error,
  }) {
    return NoticeState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NoticeNotifier extends StateNotifier<NoticeState> {
  final dynamic repository;

  NoticeNotifier(this.repository) : super(NoticeState()) {
    getNotices();
  }

  Future<void> getNotices() async {
    state = state.copyWith(isLoading: true);
    try {
      final notices = await repository.getNotices();
      state = state.copyWith(
        notices: notices,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}

final noticeDetailProvider = StateNotifierProvider.family<NoticeDetailNotifier, AsyncValue<NoticeModel>, String>((ref, id) {
  // final repository = ref.watch(dummyNoticeRepositoryProvider);  // 또는 noticeRepositoryProvider
  final repository = DummyNoticeRepository();  // 더미 데이터 사용
  return NoticeDetailNotifier(repository, id);
});

class NoticeDetailNotifier extends StateNotifier<AsyncValue<NoticeModel>> {
  final dynamic repository;
  final String noticeId;

  NoticeDetailNotifier(this.repository, this.noticeId) : super(const AsyncValue.loading()) {
    getNoticeDetail();
  }

  Future<void> getNoticeDetail() async {
    state = const AsyncValue.loading();
    try {
      final notice = await repository.getNoticeDetail(id: noticeId);
      state = AsyncValue.data(notice);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
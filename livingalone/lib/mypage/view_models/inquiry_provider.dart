import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/inquiry_model.dart';
import 'package:livingalone/mypage/repository/inquiry_repository.dart';

final inquiryProvider = StateNotifierProvider<InquiryNotifier, InquiryState>((ref) {
  // API 연동 시 사용할 코드
  // final repository = ref.watch(inquiryRepositoryProvider);

  // 더미 데이터용 repository
  final repository = ref.watch(dummyInquiryRepositoryProvider);
  return InquiryNotifier(repository);
});

class InquiryState {
  final List<InquiryModel> inquiries;
  final bool isLoading;
  final String? error;

  InquiryState({
    this.inquiries = const [],
    this.isLoading = false,
    this.error,
  });

  InquiryState copyWith({
    List<InquiryModel>? inquiries,
    bool? isLoading,
    String? error,
  }) {
    return InquiryState(
      inquiries: inquiries ?? this.inquiries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class InquiryNotifier extends StateNotifier<InquiryState> {
  final dynamic repository;  // InquiryRepository 또는 DummyInquiryRepository

  InquiryNotifier(this.repository) : super(InquiryState()) {
    getInquiries();
  }

  Future<void> getInquiries() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final inquiries = await repository.getInquiries();
      state = state.copyWith(
        inquiries: inquiries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> createInquiry({
    required String category,
    required String title,
    required String content,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await repository.createInquiry(
        category: category,
        title: title,
        content: content,
      );
      await getInquiries();  // 문의 생성 후 목록 새로고침
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;  // 에러를 상위로 전파하여 UI에서 처리할 수 있도록 함
    }
  }
}
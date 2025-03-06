import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/handover_history_model.dart';
import 'package:livingalone/mypage/repository/handover_history_repository.dart';

// TODO: API 연동 시 사용할 코드
// final handoverHistoryRepositoryProvider = Provider<HandoverHistoryRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   return HandoverHistoryRepository(dio);
// });

// Main State Provider
final handoverHistoryProvider = StateNotifierProvider<HandoverHistoryNotifier, AsyncValue<List<HandoverHistoryModel>>>((ref) {
  final repository = ref.watch(handoverHistoryRepositoryProvider);
  return HandoverHistoryNotifier(repository: repository);
});

// 필터링된 결과를 캐싱하는 프로바이더
final filteredHandoverHistoryProvider = Provider.family<List<HandoverHistoryModel>, String>((ref, filter) {
  final historyState = ref.watch(handoverHistoryProvider);
  
  return historyState.when(
    data: (history) => _filterHistory(history, filter),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Count Provider
final handoverCountProvider = Provider<Map<String, int>>((ref) {
  final historyState = ref.watch(handoverHistoryProvider);
  
  return historyState.when(
    data: (history) => _calculateCounts(history),
    loading: () => _getEmptyCounts(),
    error: (_, __) => _getEmptyCounts(),
  );
});

// Helper Functions
List<HandoverHistoryModel> _filterHistory(List<HandoverHistoryModel> history, String filter) {
  switch (filter) {
    case 'ongoing':
      return history.where((item) => !item.isTransferred && !item.isHidden).toList();
    case 'completed':
      return history.where((item) => item.isTransferred).toList();
    case 'hidden':
      return history.where((item) => item.isHidden).toList();
    default:
      return history;
  }
}

Map<String, int> _calculateCounts(List<HandoverHistoryModel> history) {
  return {
    'ongoing': history.where((item) => !item.isTransferred && !item.isHidden).length,
    'completed': history.where((item) => item.isTransferred).length,
    'hidden': history.where((item) => item.isHidden).length,
  };
}

Map<String, int> _getEmptyCounts() {
  return {'ongoing': 0, 'completed': 0, 'hidden': 0};
}

class HandoverHistoryState {
  final List<HandoverHistoryModel> handoverHistory;
  final List<HandoverHistoryModel> filteredHistory;
  final bool isLoading;
  final String? error;

  HandoverHistoryState({
    this.handoverHistory = const [],
    this.filteredHistory = const [],
    this.isLoading = false,
    this.error,
  });

  HandoverHistoryState copyWith({
    List<HandoverHistoryModel>? handoverHistory,
    List<HandoverHistoryModel>? filteredHistory,
    bool? isLoading,
    String? error,
  }) {
    return HandoverHistoryState(
      handoverHistory: handoverHistory ?? this.handoverHistory,
      filteredHistory: filteredHistory ?? this.filteredHistory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Main Notifier
class HandoverHistoryNotifier extends StateNotifier<AsyncValue<List<HandoverHistoryModel>>> {
  final HandoverHistoryRepository repository;

  HandoverHistoryNotifier({
    required this.repository,
  }) : super(const AsyncValue.loading()) {
    getHandoverHistory();
  }

  Future<void> getHandoverHistory() async {
    if (state is! AsyncLoading) {
      state = const AsyncValue.loading();
    }
    
    try {
      final history = await repository.getHandoverHistory();
      state = AsyncValue.data(history);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteHandoverHistory(String itemId) async {
    try {
      await repository.deleteHandoverHistory(itemId);
      state.whenData((history) {
        final updatedHistory = history.where((item) => item.itemId != itemId).toList();
        state = AsyncValue.data(updatedHistory);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> completeHandover(String itemId) async {
    try {
      await repository.completeHandover(itemId);
      state.whenData((history) {
        final updatedHistory = history.map((item) {
          if (item.itemId == itemId) {
            return _createUpdatedModel(item, isTransferred: true);
          }
          return item;
        }).toList();
        state = AsyncValue.data(updatedHistory);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleHidden(String itemId) async {
    state.whenData((history) {
      final updatedHistory = history.map((item) {
        if (item.itemId == itemId) {
          return _createUpdatedModel(item, isHidden: !item.isHidden);
        }
        return item;
      }).toList();
      state = AsyncValue.data(updatedHistory);
    });
  }

  // Helper method to create updated model
  HandoverHistoryModel _createUpdatedModel(
    HandoverHistoryModel item, {
    bool? isTransferred,
    bool? isHidden,
  }) {
    return HandoverHistoryModel(
      itemId: item.itemId,
      title: item.title,
      location: item.location,
      thumbnailUrl: item.thumbnailUrl,
      type: item.type,
      createdAt: item.createdAt,
      viewCount: item.viewCount,
      commentCount: item.commentCount,
      chatCount: item.chatCount,
      isTransferred: isTransferred ?? item.isTransferred,
      isHidden: isHidden ?? item.isHidden,
      buildingType: item.buildingType,
      propertyType: item.propertyType,
      rentType: item.rentType,
      deposit: item.deposit,
      monthlyRent: item.monthlyRent,
      ticketType: item.ticketType,
      remainingDays: item.remainingDays,
      price: item.price,
    );
  }
} 
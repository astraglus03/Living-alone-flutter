import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/neighbor_activity_model.dart';
import 'package:livingalone/mypage/repository/neighbor_activity_repository.dart';

// Main State Provider
final neighborActivityProvider = StateNotifierProvider<NeighborActivityNotifier, AsyncValue<List<NeighborActivityModel>>>((ref) {
  final repository = ref.watch(neighborActivityRepositoryProvider);
  return NeighborActivityNotifier(repository: repository);
});

// Filtered Activities Provider
final filteredNeighborActivityProvider = Provider.family<List<NeighborActivityModel>, String>((ref, type) {
  final activitiesState = ref.watch(neighborActivityProvider);
  
  return activitiesState.when(
    data: (activities) {
      if (type == 'my') {
        return activities.where((activity) => activity.isMyPost).toList();
      } else if (type == 'participated') {
        return activities.where((activity) => activity.isParticipated).toList();
      }
      return activities;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Count Provider
final neighborActivityCountProvider = Provider<Map<String, int>>((ref) {
  final activitiesState = ref.watch(neighborActivityProvider);
  
  return activitiesState.when(
    data: (activities) => _calculateCounts(activities),
    loading: () => _getEmptyCounts(),
    error: (_, __) => _getEmptyCounts(),
  );
});

// Helper Functions
Map<String, int> _calculateCounts(List<NeighborActivityModel> activities) {
  return {
    'my': activities.where((activity) => activity.isMyPost).length,
    'participated': activities.where((activity) => activity.isParticipated).length,
  };
}

Map<String, int> _getEmptyCounts() {
  return {
    'my': 0,
    'participated': 0,
  };
}

// Main Notifier
class NeighborActivityNotifier extends StateNotifier<AsyncValue<List<NeighborActivityModel>>> {
  final NeighborActivityRepository repository;

  NeighborActivityNotifier({
    required this.repository,
  }) : super(const AsyncValue.loading()) {
    getActivities();
  }

  Future<void> getActivities({String? type}) async {
    if (state is! AsyncLoading) {
      state = const AsyncValue.loading();
    }
    
    try {
      final activities = await repository.getActivities(type: type);
      state = AsyncValue.data(activities);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleLike(String id) async {
    try {
      await repository.toggleLike(id);
      final activities = await repository.getActivities();
      state = AsyncValue.data(activities);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 
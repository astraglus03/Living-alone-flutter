import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/mypage/models/favorite_model.dart';
import 'package:livingalone/mypage/repository/favorite_repository.dart';

// TODO: API 연동 시 사용할 코드
// final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
//   final dio = ref.watch(dioProvider);
//   return FavoriteRepository(dio);
// });

// Repository Provider
final favoriteRepositoryProvider = Provider<DummyFavoriteRepository>((ref) {
  return DummyFavoriteRepository();
});

// Main State Provider
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, AsyncValue<List<FavoriteModel>>>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return FavoriteNotifier(repository: repository);
});

// Filtered Favorites Provider
final filteredFavoriteProvider = Provider.family<List<FavoriteModel>, String>((ref, filter) {
  final favoritesState = ref.watch(favoriteProvider);
  
  return favoritesState.when(
    data: (favorites) => _filterFavorites(favorites, filter),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Count Provider
final favoriteCountProvider = Provider<Map<String, int>>((ref) {
  final favoritesState = ref.watch(favoriteProvider);
  
  return favoritesState.when(
    data: (favorites) => _calculateCounts(favorites),
    loading: () => _getEmptyCounts(),
    error: (_, __) => _getEmptyCounts(),
  );
});

// Helper Functions
List<FavoriteModel> _filterFavorites(List<FavoriteModel> favorites, String filter) {
  if (filter == '전체') {
    return favorites;
  }
  return favorites.where((item) => 
    filter == '자취방' ? item.type == PostType.room : item.type == PostType.ticket
  ).toList();
}

Map<String, int> _calculateCounts(List<FavoriteModel> favorites) {
  return {
    '전체': favorites.length,
    '자취방': favorites.where((item) => item.type == PostType.room).length,
    '이용권': favorites.where((item) => item.type == PostType.ticket).length,
  };
}

Map<String, int> _getEmptyCounts() {
  return {'전체': 0, '자취방': 0, '이용권': 0};
}

// Main Notifier
class FavoriteNotifier extends StateNotifier<AsyncValue<List<FavoriteModel>>> {
  // final FavoriteRepository repository;
  final DummyFavoriteRepository repository;

  FavoriteNotifier({
    required this.repository,
  }) : super(const AsyncValue.loading()) {
    getFavorites();
  }

  Future<void> getFavorites({String? type}) async {
    if (state is! AsyncLoading) {
      state = const AsyncValue.loading();
    }
    
    try {
      final favorites = await repository.getFavorites(type: type);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite({
    required String itemId,
    required String type,
    required bool isFavorite,
  }) async {
    try {
      if (isFavorite) {
        await repository.removeFavorite(itemId: itemId, type: type);
        state.whenData((favorites) {
          final updatedFavorites = favorites.where((item) => item.itemId != itemId).toList();
          state = AsyncValue.data(updatedFavorites);
        });
      } else {
        final newFavorite = await repository.addFavorite(itemId: itemId, type: type);
        state.whenData((favorites) {
          state = AsyncValue.data([...favorites, newFavorite]);
        });
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 
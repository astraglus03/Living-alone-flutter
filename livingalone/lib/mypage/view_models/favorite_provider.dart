import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/favorite_model.dart';
import 'package:livingalone/mypage/repository/favorite_repository.dart';

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, FavoriteState>((ref) {
  // API 연동 시 사용할 코드
  // final repository = ref.watch(favoriteRepositoryProvider);
  
  // 더미 데이터용
  final repository = ref.watch(dummyFavoriteRepositoryProvider);
  return FavoriteNotifier(repository);
});

class FavoriteState {
  final List<FavoriteModel> allFavorites;
  final List<FavoriteModel> filteredFavorites;
  final bool isLoading;
  final String? error;
  final String? selectedType;

  FavoriteState({
    this.allFavorites = const [],
    this.filteredFavorites = const [],
    this.isLoading = false,
    this.error,
    this.selectedType,
  });

  FavoriteState copyWith({
    List<FavoriteModel>? allFavorites,
    List<FavoriteModel>? filteredFavorites,
    bool? isLoading,
    String? error,
    String? selectedType,
  }) {
    return FavoriteState(
      allFavorites: allFavorites ?? this.allFavorites,
      filteredFavorites: filteredFavorites ?? this.filteredFavorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  final FavoriteRepository repository;

  FavoriteNotifier(this.repository) : super(FavoriteState()) {
    getFavorites();
  }

  Future<void> getFavorites({String? type}) async {
    // 이미 데이터가 있고 타입만 변경하는 경우 로컬 필터링
    if (state.allFavorites.isNotEmpty && type != null) {
      _filterFavorites(type);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final favorites = await repository.getFavorites();
      // 시간순 정렬 (최신순)
      favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final filteredList = type == null 
          ? favorites 
          : favorites.where((f) => f.type.toString() == type).toList();

      state = state.copyWith(
        allFavorites: favorites,
        filteredFavorites: filteredList,
        isLoading: false,
        selectedType: type,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void _filterFavorites(String? type) {
    if (type == null) {
      state = state.copyWith(
        filteredFavorites: state.allFavorites,
        selectedType: null,
      );
      return;
    }

    final filtered = state.allFavorites
        .where((favorite) => favorite.type.toString() == type)
        .toList();

    state = state.copyWith(
      filteredFavorites: filtered,
      selectedType: type,
    );
  }

  Future<void> toggleFavorite({
    required String itemId,
    required String type,
    required bool isFavorite,
  }) async {
    try {
      // UI 상태 즉시 업데이트 (전체 목록과 필터링된 목록 모두 업데이트)
      final updatedAllFavorites = state.allFavorites.map((favorite) {
        if (favorite.itemId == itemId) {
          favorite.isFavorite = !isFavorite;
        }
        return favorite;
      }).toList();

      final updatedFilteredFavorites = state.filteredFavorites.map((favorite) {
        if (favorite.itemId == itemId) {
          favorite.isFavorite = !isFavorite;
        }
        return favorite;
      }).toList();
      
      state = state.copyWith(
        allFavorites: updatedAllFavorites,
        filteredFavorites: updatedFilteredFavorites,
      );

      // API 호출
      if (isFavorite) {
        await repository.removeFavorite(
          itemId: itemId,
          type: type,
        );
      } else {
        await repository.addFavorite(
          itemId: itemId,
          type: type,
        );
      }
    } catch (e) {
      // API 호출 실패 시 UI 상태 복구
      final revertedAllFavorites = state.allFavorites.map((favorite) {
        if (favorite.itemId == itemId) {
          favorite.isFavorite = isFavorite;
        }
        return favorite;
      }).toList();

      final revertedFilteredFavorites = state.filteredFavorites.map((favorite) {
        if (favorite.itemId == itemId) {
          favorite.isFavorite = isFavorite;
        }
        return favorite;
      }).toList();
      
      state = state.copyWith(
        allFavorites: revertedAllFavorites,
        filteredFavorites: revertedFilteredFavorites,
        error: e.toString(),
      );
    }
  }
} 
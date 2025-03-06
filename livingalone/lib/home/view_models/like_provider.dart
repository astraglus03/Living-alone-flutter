import 'package:flutter_riverpod/flutter_riverpod.dart';

// 좋아요 상태를 매물 ID와 함께 저장
class LikeState {
  final Map<String, bool> likedPosts;  // postId: isLiked
  
  LikeState({
    Map<String, bool>? likedPosts,
  }) : likedPosts = likedPosts ?? {};

  LikeState copyWith({
    Map<String, bool>? likedPosts,
  }) {
    return LikeState(
      likedPosts: likedPosts ?? this.likedPosts,
    );
  }

  List<String> get likedPostIds => 
    likedPosts.entries.where((e) => e.value).map((e) => e.key).toList();
}

class LikeNotifier extends StateNotifier<LikeState> {
  LikeNotifier() : super(LikeState());

  void toggleLike(String postId) {
    final currentLikes = Map<String, bool>.from(state.likedPosts);
    currentLikes[postId] = !(currentLikes[postId] ?? false);
    
    state = state.copyWith(likedPosts: currentLikes);
    // TODO: 서버에 좋아요 상태 업데이트
  }

  bool isLiked(String postId) {
    return state.likedPosts[postId] ?? false;
  }

  // 좋아요한 게시물 ID 목록 반환
  List<String> getLikedPosts() {
    return state.likedPostIds;
  }
}

final likeProvider = StateNotifierProvider<LikeNotifier, LikeState>((ref) {
  return LikeNotifier();
}); 
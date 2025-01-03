
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/room_post_model.dart';
import '../repository/room_post_repository.dart';

final postProvider = StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostNotifier(repository);
});

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostRepository _repository;
  int _page = 1;
  bool _hasMore = true;

  PostNotifier(this._repository) : super(AsyncValue.loading()) {
    loadPosts();
  }

  Future<void> loadPosts() async {
    if (!_hasMore) return;

    try {
      final newPosts = await _repository.fetchPosts(_page);
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        state = AsyncValue.data([...state.asData?.value ?? [], ...newPosts]);
        _page++;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void refreshPosts() {
    _page = 1;
    _hasMore = true;
    state = AsyncValue.loading();
    loadPosts();
  }
}

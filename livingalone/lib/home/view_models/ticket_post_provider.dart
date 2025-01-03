import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket_post_model.dart';
import '../repository/ticket_post_repository.dart';

final ticketPostProvider = StateNotifierProvider<TicketPostNotifier, AsyncValue<List<TicketPost>>>((ref) {
  final repository = ref.watch(ticketPostRepositoryProvider);
  return TicketPostNotifier(repository);
});

class TicketPostNotifier extends StateNotifier<AsyncValue<List<TicketPost>>> {
  final TicketPostRepository _repository;
  int _page = 1;
  bool _hasMore = true;

  TicketPostNotifier(this._repository) : super(AsyncValue.loading()) {
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/neighbor/models/neighbor_comment_model.dart';
import 'package:livingalone/neighbor/repository/neighbor_comment_repository.dart';

// ==================== Providers ====================
final neighborCommentsProvider = StateNotifierProvider.family<NeighborCommentsNotifier,
    NeighborCommentsState, String>((ref, postId) {
  // 더미 데이터용 repository 사용 (테스트용)
  final repository = ref.watch(dummyCommentRepositoryProvider);
  return NeighborCommentsNotifier(
    postId: postId,
    repository: repository,
  );

  // API 연동 시 아래 코드로 변경
  /*
  final repository = ref.watch(CommunityCommentRepositoryProvider(postId));
  return NeighborCommentsNotifier(
    postId: postId,
    repository: repository,
  );
  */
});

// ==================== State ====================
class NeighborCommentsState {
  final List<NeighborCommentModel> comments;
  final int totalCommentsCount;
  final bool isLoading;
  final String? error;

  const NeighborCommentsState({
    required this.comments,
    required this.totalCommentsCount,
    this.isLoading = false,
    this.error,
  });

  NeighborCommentsState copyWith({
    List<NeighborCommentModel>? comments,
    int? totalCommentsCount,
    bool? isLoading,
    String? error,
  }) {
    return NeighborCommentsState(
      comments: comments ?? this.comments,
      totalCommentsCount: totalCommentsCount ?? this.totalCommentsCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ==================== Notifier ====================
class NeighborCommentsNotifier extends StateNotifier<NeighborCommentsState> {
  final String postId;
  final dynamic repository;

  NeighborCommentsNotifier({
    required this.postId,
    required this.repository,
  }) : super(const NeighborCommentsState(comments: [], totalCommentsCount: 0)) {
    getComments();
  }

  // ==================== API 통신 메서드 (현재는 주석 처리) ====================
  /*
  Future<void> getComments() async {
    state = state.copyWith(isLoading: true);
    try {
      final comments = await repository.getComments(postId);
      final totalCount = _calculateTotalCount(comments);
      state = state.copyWith(
        comments: comments,
        totalCommentsCount: totalCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> addComment(String content) async {
    try {
      final newComment = await repository.createComment(
        postId,
        {
          'content': content,
        },
      );
      final newComments = [...state.comments, newComment];
      state = state.copyWith(
        comments: newComments,
        totalCommentsCount: state.totalCommentsCount + 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addReply(String commentId, String content) async {
    try {
      final newReply = await repository.createReply(
        postId,
        commentId,
        {
          'content': content,
        },
      );
      _updateCommentsWithNewReply(commentId, newReply);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await repository.deleteComment(postId, commentId);
      _handleCommentDeletion(commentId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteReply(String commentId, String replyId) async {
    try {
      await repository.deleteReply(postId, commentId, replyId);
      _handleReplyDeletion(commentId, replyId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  */

  // ==================== 더미 데이터 처리 메서드 (현재 사용 중) ====================
  Future<void> getComments() async {
    state = state.copyWith(isLoading: true);
    try {
      final List<NeighborCommentModel> comments = await repository.getDummyComments(postId);
      final totalCount = _calculateTotalCount(comments);
      state = state.copyWith(
        comments: comments,
        totalCommentsCount: totalCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> addComment(String content) async {
    try {
      final newComment = await repository.createDummyComment(
        postId,
        {
          'username': '고얌미',
          'content': content,
        },
      );
      final List<NeighborCommentModel> newComments = [...state.comments, newComment];
      state = state.copyWith(
        comments: newComments,
        totalCommentsCount: state.totalCommentsCount + 1,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addReply(String commentId, String content) async {
    try {
      final newReply = await repository.createDummyReply(
        postId,
        commentId,
        {
          'username': '고얌미',
          'content': content,
        },
      );
      _updateCommentsWithNewReply(commentId, newReply);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        _handleCommentDeletion(commentId);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteReply(String commentId, String replyId) async {
    try {
      final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        _handleReplyDeletion(commentId, replyId);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // ==================== 유틸리티 메서드 ====================
  int _calculateTotalCount(List<NeighborCommentModel> comments) {
    return comments.fold(0, (sum, comment) =>
      sum + 1 + (comment.replies?.length ?? 0)
    );
  }

  void _updateCommentsWithNewReply(String commentId, NeighborCommentModel newReply) {
    final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      final newComments = [...state.comments];
      final comment = newComments[commentIndex];
      final currentReplies = comment.replies ?? [];
      newComments[commentIndex] = comment.copyWith(
        replies: [...currentReplies, newReply],
      );
      state = state.copyWith(
        comments: newComments,
        totalCommentsCount: state.totalCommentsCount + 1,
      );
    }
  }

  void _handleCommentDeletion(String commentId) {
    final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      final comment = state.comments[commentIndex];
      final hasReplies = comment.replies != null && comment.replies!.isNotEmpty;

      if (hasReplies) {
        // 답글이 있는 경우: "삭제된 댓글입니다." 표시
        final newComments = [...state.comments];
        newComments[commentIndex] = comment.copyWith(
          isDeleted: true,
          content: '삭제된 댓글입니다.',
        );
        state = state.copyWith(
          comments: newComments,
          totalCommentsCount: state.totalCommentsCount - 1,
        );
      } else {
        // 답글이 없는 경우: 댓글 자체를 제거
        final newComments = [...state.comments];
        newComments.removeAt(commentIndex);
        state = state.copyWith(
          comments: newComments,
          totalCommentsCount: state.totalCommentsCount - 1,
        );
      }
    }
  }

  void _handleReplyDeletion(String commentId, String replyId) {
    final commentIndex = state.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex != -1) {
      final comment = state.comments[commentIndex];
      if (comment.replies != null) {
        final newReplies = [...comment.replies!];
        newReplies.removeWhere((r) => r.id == replyId);

        final newComments = [...state.comments];

        if (comment.isDeleted && newReplies.isEmpty) {
          // 원본 댓글이 삭제된 상태이고 답글이 없는 경우: 전체 제거
          newComments.removeAt(commentIndex);
          state = state.copyWith(
            comments: newComments,
            totalCommentsCount: state.totalCommentsCount - 1,
          );
        } else {
          // 그 외의 경우: 답글만 제거
          newComments[commentIndex] = comment.copyWith(replies: newReplies);
          state = state.copyWith(
            comments: newComments,
            totalCommentsCount: state.totalCommentsCount - 1,
          );
        }
      }
    }
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/home/models/comment_model.dart';

class CommentsNotifier extends StateNotifier<List<CommentModel>> {
  CommentsNotifier() : super([]);

  void setComments(List<CommentModel> comments) {
    state = List<CommentModel>.from(comments);
  }

  void addComment(CommentModel comment) {
    state = [...state, comment];
  }

  void deleteComment(int index) {
    final newComments = List<CommentModel>.from(state);
    if (newComments[index].replies != null && newComments[index].replies!.isNotEmpty) {
      newComments[index] = newComments[index].copyWithDeleted();
    } else {
      newComments.removeAt(index);
    }
    state = newComments;
  }

  void deleteReply(int commentIndex, int replyIndex) {
    final newComments = List<CommentModel>.from(state);
    final comment = newComments[commentIndex];
    final newReplies = List<CommentModel>.from(comment.replies ?? []);

    newReplies.removeAt(replyIndex);

    if (newReplies.isEmpty && comment.isDeleted) {
      newComments.removeAt(commentIndex);
    } else {
      newComments[commentIndex] = CommentModel(
        username: comment.username,
        content: comment.content,
        time: comment.time,
        replies: newReplies,
        isAuthor: comment.isAuthor,
        isDeleted: comment.isDeleted,
      );
    }

    state = newComments;
  }
}

final commentsProvider = StateNotifierProvider<CommentsNotifier, List<CommentModel>>((ref) {
  return CommentsNotifier();
});
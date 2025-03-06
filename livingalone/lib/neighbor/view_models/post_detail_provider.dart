import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/neighbor/models/post_detail_model.dart';
import 'package:livingalone/neighbor/repository/community_repository.dart';

class PostDetailState {
  final PostDetailModel? post;
  final bool isLoading;
  final String? error;

  PostDetailState({
    this.post,
    this.isLoading = false,
    this.error,
  });

  PostDetailState copyWith({
    PostDetailModel? post,
    bool? isLoading,
    String? error,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final postDetailProvider = StateNotifierProvider.family<PostDetailNotifier, PostDetailState, String>((ref, postId) {
  final repository = ref.watch(communityRepositoryProvider);
  return PostDetailNotifier(repository, postId);
});

class PostDetailNotifier extends StateNotifier<PostDetailState> {
  final CommunityRepository repository;
  final String postId;

  PostDetailNotifier(this.repository, this.postId) : super(PostDetailState()) {
    // 초기화 시 게시글 정보를 가져옵니다.
    getPostDetail();
  }

  Future<void> getPostDetail() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // API 호출 대신 더미데이터 사용
      await Future.delayed(Duration(milliseconds: 500)); // 로딩 효과를 위한 지연
      final post = PostDetailModel.getDummy();
      
      // TODO: API 연동 시 아래 코드 사용
      // final post = await _repository.getPostDetail(
      //   communityId: '1',
      //   postId: postId,
      // );
      
      state = state.copyWith(post: post, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleLike() async {
    if (state.post == null) return;

    try {
      // API 호출 대신 상태만 직접 변경
      final currentPost = state.post!;
      final updatedPost = PostDetailModel(
        id: currentPost.id,
        topic: currentPost.topic,
        title: currentPost.title,
        content: currentPost.content,
        imageUrls: currentPost.imageUrls,
        authorId: currentPost.authorId,
        authorName: currentPost.authorName,
        authorProfileUrl: currentPost.authorProfileUrl,
        createdAt: currentPost.createdAt,
        likeCount: currentPost.isLiked ? currentPost.likeCount - 1 : currentPost.likeCount + 1,
        commentCount: currentPost.commentCount,
        isLiked: !currentPost.isLiked,
      );

      // TODO: API 연동 시 아래 코드 사용
      // if (state.post!.isLiked) {
      //   await _repository.unlikePost(
      //     communityId: '1',
      //     postId: postId,
      //   );
      // } else {
      //   await _repository.likePost(
      //     communityId: '1',
      //     postId: postId,
      //   );
      // }
      // await getPostDetail();

      state = state.copyWith(post: updatedPost);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
} 
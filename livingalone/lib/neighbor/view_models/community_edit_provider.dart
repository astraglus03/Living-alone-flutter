import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:livingalone/neighbor/models/post_community_model.dart';
import 'package:livingalone/neighbor/repository/community_repository.dart';

class CommunityEditState {
  final String topic;
  final String title;
  final String content;
  final List<String> images;
  final bool isLoading;
  final String? error;

  const CommunityEditState({
    this.topic = '',
    this.title = '',
    this.content = '',
    this.images = const [],
    this.isLoading = false,
    this.error,
  });

  CommunityEditState copyWith({
    String? topic,
    String? title,
    String? content,
    List<String>? images,
    bool? isLoading,
    String? error,
  }) {
    return CommunityEditState(
      topic: topic ?? this.topic,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final communityEditProvider = StateNotifierProvider.family<CommunityEditNotifier,
    CommunityEditState, String>((ref, postId) {
  final repository = ref.watch(communityRepositoryProvider);
  return CommunityEditNotifier(
    postId: postId,
    repository: repository,
  );
});

class CommunityEditNotifier extends StateNotifier<CommunityEditState> {
  final String postId;
  final CommunityRepository repository;

  CommunityEditNotifier({
    required this.postId,
    required this.repository,
  }) : super(const CommunityEditState());

  Future<void> getPost() async {
    state = state.copyWith(isLoading: true);
    try {
      final post = await repository.getPostDetail(
        communityId: '1',
        postId: postId,
      );
      
      state = state.copyWith(
        topic: post.topic,
        title: post.title,
        content: post.content,
        images: post.imageUrls,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void updateTopic(String topic) {
    state = state.copyWith(topic: topic);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void setImages(List<String> images) {
    state = state.copyWith(images: images);
  }

  void addImage(String imageUrl) {
    final newImages = [...state.images, imageUrl];
    state = state.copyWith(images: newImages);
  }

  void reorderImages(int oldIndex, int newIndex) {
    final newImages = [...state.images];
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = newImages.removeAt(oldIndex);
    newImages.insert(newIndex, item);
    state = state.copyWith(images: newImages);
  }

  Future<bool> updatePost() async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.updatePost(
        communityId: '1',
        postId: postId,
        body: PostCommunityModel(
          topic: state.topic,
          title: state.title,
          content: state.content,
          imageUrls: state.images,
        ),
      );
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> uploadImages(List<MultipartFile> images) async {
    state = state.copyWith(isLoading: true);
    try {
      final uploadedUrls = await Future.wait(
        images.map((image) => repository.uploadImage(
          communityId: '1',
          filePath: image.filename!,
        )),
      );
      
      state = state.copyWith(
        images: [...state.images, ...uploadedUrls],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void removeImage(String imageUrl) {
    final newImages = [...state.images];
    newImages.remove(imageUrl);
    state = state.copyWith(images: newImages);
  }
} 
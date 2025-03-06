import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/neighbor/repository/community_repository.dart';
import 'package:livingalone/neighbor/models/post_community_model.dart';

class WriteCommunityState {
  final String topic;
  final String title;
  final String content;
  final List<File> images;
  final bool isLoading;
  final String? error;

  WriteCommunityState({
    this.topic = '',
    this.title = '',
    this.content = '',
    this.images = const [],
    this.isLoading = false,
    this.error,
  });

  WriteCommunityState copyWith({
    String? topic,
    String? title,
    String? content,
    List<File>? images,
    bool? isLoading,
    String? error,
  }) {
    return WriteCommunityState(
      topic: topic ?? this.topic,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final writeCommunityProvider = StateNotifierProvider<WriteCommunityNotifier, WriteCommunityState>((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  return WriteCommunityNotifier(repository);
});

class WriteCommunityNotifier extends StateNotifier<WriteCommunityState> {
  final CommunityRepository _repository;

  WriteCommunityNotifier(this._repository) : super(WriteCommunityState());

  void updateTopic(String topic) {
    state = state.copyWith(topic: topic);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void addImages(List<File> newImages) {
    final updatedImages = [...state.images, ...newImages];
    state = state.copyWith(images: updatedImages);
  }

  // void removeImage(int index) {
  //   final updatedImages = [...state.images];
  //   updatedImages.removeAt(index);
  //   state = state.copyWith(images: updatedImages);
  // }
  //
  // void reorderImages(int oldIndex, int newIndex) {
  //   final updatedImages = [...state.images];
  //   if (oldIndex < newIndex) {
  //     newIndex -= 1;
  //   }
  //   final File item = updatedImages.removeAt(oldIndex);
  //   updatedImages.insert(newIndex, item);
  //   state = state.copyWith(images: updatedImages);
  // }

  // void reset() {
  //   state = WriteCommunityState();
  // }

  bool validateForm() {
    return state.topic.isNotEmpty && 
           state.title.isNotEmpty && 
           state.content.isNotEmpty;
  }

  Future<bool> submitPost(String communityId) async {
    if (!validateForm()) {
      return false;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final postBody = PostCommunityModel(
        topic: state.topic,
        title: state.title,
        content: state.content,
        imageUrls: state.images.map((file) => file.path).toList(),
      );

      await _repository.createPost(
        communityId: communityId,
        body: postBody,
      );

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
} 
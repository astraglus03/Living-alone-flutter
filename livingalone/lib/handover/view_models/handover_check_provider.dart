import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/enum/post_type.dart';

final handoverCheckProvider = StateNotifierProvider<HandoverCheckNotifier, HandoverCheckState>((ref) {
  return HandoverCheckNotifier();
});

class HandoverCheckState {
  final PostType postType;
  final bool isChecked;
  final DateTime? checkedAt;

  HandoverCheckState({
    required this.postType,
    this.isChecked = false,
    this.checkedAt,
  });

  HandoverCheckState copyWith({
    PostType? postType,
    bool? isChecked,
    DateTime? checkedAt,
  }) {
    return HandoverCheckState(
      postType: postType ?? this.postType,
      isChecked: isChecked ?? this.isChecked,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }
}

class HandoverCheckNotifier extends StateNotifier<HandoverCheckState> {
  HandoverCheckNotifier() : super(HandoverCheckState(postType: PostType.room));

  void setPostType(PostType type) {
    state = state.copyWith(postType: type);
  }

  void confirmCheck() {
    state = state.copyWith(
      isChecked: true,
      checkedAt: DateTime.now(),
    );
  }
} 
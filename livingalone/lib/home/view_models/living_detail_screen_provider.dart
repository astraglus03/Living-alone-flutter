import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/home/models/comment_model.dart';

final LivingDetailScreenProvider = StateNotifierProvider<LivingDetailScreenNotifier, LivingDetailScreenState>((ref) {
  return LivingDetailScreenNotifier();
});


class LivingDetailScreenState {
  final bool showTabBar;
  final double tabBarOpacity;
  final Map<String, GlobalKey> sectionKeys;
  final List<CommentModel> comments;

  LivingDetailScreenState({
    this.showTabBar = false,
    this.tabBarOpacity = 0.0,
    required this.sectionKeys,
    this.comments = const [],
  });

  int get totalCommentsCount {
    int total = 0;
    for (var comment in comments) {
      if (!comment.isDeleted) {
        total += 1;
      }
      if (comment.replies != null) {
        total += comment.replies!.length;
      }
    }
    return total;
  }

  LivingDetailScreenState copyWith({
    bool? showTabBar,
    double? tabBarOpacity,
    Map<String, GlobalKey>? sectionKeys,
    List<CommentModel>? comments,
  }) {
    return LivingDetailScreenState(
      showTabBar: showTabBar ?? this.showTabBar,
      tabBarOpacity: tabBarOpacity ?? this.tabBarOpacity,
      sectionKeys: sectionKeys ?? this.sectionKeys,
      comments: comments ?? this.comments,
    );
  }
}

class LivingDetailScreenNotifier extends StateNotifier<LivingDetailScreenState> {
  LivingDetailScreenNotifier() : super(LivingDetailScreenState(sectionKeys: {
    '매물 소개': GlobalKey(),
    '방 정보': GlobalKey(),
    '이용권 소개': GlobalKey(),
    '이용권 정보': GlobalKey(),
    '위치': GlobalKey(),
    '댓글': GlobalKey(),
  }));

  void updateTabBarVisibility(double scrollOffset) {
    final threshold = 620.0;
    final transitionDistance = 150.0;
    
    final rawOpacity = ((scrollOffset - (threshold - transitionDistance)) / transitionDistance)
        .clamp(0.0, 1.0);
    final opacity = Curves.easeInOut.transform(rawOpacity);

    if ((opacity - state.tabBarOpacity).abs() > 0.01) {
      state = state.copyWith(
        tabBarOpacity: opacity,
        showTabBar: opacity > 0.01,
      );
    }
  }

  void scrollToSection(String title, ScrollController scrollController) {
    final key = state.sectionKeys[title];
    if (key?.currentContext == null) return;

    final RenderBox renderBox = key!.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    final targetScroll = scrollController.offset + position.dy - 170;

    scrollController.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateCurrentSection(ScrollController scrollController, TabController tabController, PostType postType) {
    String? currentSection;

    final isNearBottom = scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100;

    if (isNearBottom) {
      currentSection = '댓글';
    } else {
      state.sectionKeys.forEach((title, key) {
        if (key.currentContext != null) {
          final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
          final offset = box.localToGlobal(Offset.zero).dy;

          if (offset < 180 && offset > -100) {
            currentSection = title;
          }
        }
      });
    }

    if (currentSection != null) {
      int newIndex;
      if (postType == PostType.room) {
        newIndex = switch (currentSection) {
          '매물 소개' => 0,
          '방 정보' => 1,
          '위치' => 2,
          '댓글' => 3,
          _ => tabController.index,
        };
      } else {
        newIndex = switch (currentSection) {
          '이용권 소개' => 0,
          '이용권 정보' => 1,
          '위치' => 2,
          '댓글' => 3,
          _ => tabController.index,
        };
      }

      if (tabController.index != newIndex) {
        tabController.animateTo(newIndex);
      }
    }
  }

  void setComments(List<CommentModel> comments) {
    state = state.copyWith(comments: List<CommentModel>.from(comments));
  }

  void addComment(CommentModel comment) {
    final newComments = List<CommentModel>.from(state.comments)..add(comment);
    state = state.copyWith(comments: newComments);
  }

  void deleteComment(int index) {
    final newComments = List<CommentModel>.from(state.comments);
    if (newComments[index].replies != null && newComments[index].replies!.isNotEmpty) {
      newComments[index] = newComments[index].copyWithDeleted();
    } else {
      newComments.removeAt(index);
    }
    state = state.copyWith(comments: newComments);
  }

  void deleteReply(int commentIndex, int replyIndex) {
    final newComments = List<CommentModel>.from(state.comments);
    final comment = newComments[commentIndex];
    final newReplies = List<CommentModel>.from(comment.replies ?? []);
    
    // 대댓글 삭제
    newReplies.removeAt(replyIndex);
    
    // 대댓글이 모두 삭제되고 댓글이 삭제 상태면 댓글 자체를 완전히 제거
    if (newReplies.isEmpty && comment.isDeleted) {
      newComments.removeAt(commentIndex);
    } else {
      // 그 외의 경우는 대댓글 목록만 업데이트
      newComments[commentIndex] = CommentModel(
        username: comment.username,
        content: comment.content,
        time: comment.time,
        replies: newReplies,
        isAuthor: comment.isAuthor,
        isDeleted: comment.isDeleted,
      );
    }
    
    state = state.copyWith(comments: newComments);
  }
}
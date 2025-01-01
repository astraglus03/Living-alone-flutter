import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:livingalone/home/models/post_type.dart';

final LivingDetailScreenProvider = StateNotifierProvider<LivingDetailScreenNotifier, DetailScreenState>((ref) {
  return LivingDetailScreenNotifier();
});

class DetailScreenState {
  final double tabBarOpacity;
  final bool showTabBar;
  final int currentTabIndex;
  final Map<String, GlobalKey> sectionKeys;

  DetailScreenState({
    this.tabBarOpacity = 0.0,
    this.showTabBar = false,
    this.currentTabIndex = 0,
    Map<String, GlobalKey>? sectionKeys,
  }) : sectionKeys = sectionKeys ?? {
    '매물 소개': GlobalKey(),
    '방 정보': GlobalKey(),
    '이용권 소개': GlobalKey(),
    '이용권 정보': GlobalKey(),
    '위치': GlobalKey(),
    '댓글': GlobalKey(),
  };

  DetailScreenState copyWith({
    double? tabBarOpacity,
    bool? showTabBar,
    int? currentTabIndex,
  }) {
    return DetailScreenState(
      tabBarOpacity: tabBarOpacity ?? this.tabBarOpacity,
      showTabBar: showTabBar ?? this.showTabBar,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      sectionKeys: sectionKeys,
    );
  }
}

class LivingDetailScreenNotifier extends StateNotifier<DetailScreenState> {
  LivingDetailScreenNotifier() : super(DetailScreenState());

  void updateTabBarVisibility(double scrollOffset) {
    final threshold = 620.0;
    final opacity = ((scrollOffset - (threshold - 100)) / 100).clamp(0.0, 1.0);

    if (opacity != state.tabBarOpacity) {
      state = state.copyWith(
        tabBarOpacity: opacity,
        showTabBar: opacity > 0,
      );
    }
  }

  void scrollToSection(String title, ScrollController scrollController) {
    final key = state.sectionKeys[title];
    if (key?.currentContext == null) return;

    final RenderBox renderBox = key!.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    // AppBar 높이(56) + TabBar 높이(48) + 여백(24)
    final targetScroll = scrollController.offset + position.dy - 170;

    scrollController.animateTo(
      targetScroll,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateCurrentSection(ScrollController scrollController, TabController tabController, PostType postType) {
    // 현재 보이는 섹션 찾기
    String? currentSection;

    // 스크롤이 거의 끝에 도달했는지 확인
    final isNearBottom = scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100;  // 하단 100px 여유

    if (isNearBottom) {
      // 스크롤이 거의 끝에 도달했다면 마지막 탭(댓글)으로 설정
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
      if (postType == PostType.ROOM) {
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
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/check_room_handover_screen.dart';
import 'package:livingalone/handover/view/check_ticket_handover_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../common/const/text_styles.dart';
import '../models/room_post_model.dart';
import '../view_models/room_post_tile.dart';
import 'package:dotted_line/dotted_line.dart';
import '../component/filterchip.dart';
import '../component/search_bar.dart';
import '../view_models/board_tab_provider.dart';
import '../widget/ticket_filter_chip_list.dart';
import '../widget/board_tab_bar.dart';
import '../widget/room_filter_chip_list.dart';
import '../models/ticket_post_model.dart';
import '../view_models/ticket_post_provider.dart';
import '../widget/room_post_list.dart';
import '../widget/ticket_post_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ValueNotifier<bool> _openCloseDial = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(boardTabProvider);
    final roomPostsState = ref.watch(postProvider);
    final ticketPostsState = ref.watch(ticketPostProvider);

    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      appbarTitleBackgroundColor: WHITE100_COLOR,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              onNotificationTap: () {
                // 알림 처리
              },
            ),
            SizedBox(height: 10),
            BoardTabBar(),
            SizedBox(height: 12),

            // 탭에 따른 필터
            if (currentTab == 0)
              RoomFilterChipList()
            else
              BoardFilterChipList(),

            SizedBox(height: 16),

            // 탭에 따른 게시물 목록
            Expanded(
                child: currentTab == 0
                    ? roomPostsState.when(
                        data: (posts) => PostList(posts: posts),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                      )
                    : ticketPostsState.when(
                        data: (ticketposts) => TicketPostList(ticketposts: ticketposts),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                      )),
          ],
        ),
      ),
    );
  }
}

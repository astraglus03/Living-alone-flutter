import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/layout/default_layout.dart';
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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isDialogVisible = false;

  Widget _buildMenuItem({
    required String path,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("$path", colorFilter: ColorFilter.mode(BLUE400_COLOR, BlendMode.srcIn),),
            SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body2,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(boardTabProvider);
    final roomPostsState = ref.watch(postProvider);
    final ticketPostsState = ref.watch(ticketPostProvider);

    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      appbarTitleBackgroundColor: WHITE100_COLOR,
      floatingActionButton: Stack(
        children: [
          if (_isDialogVisible)
            Positioned(
              bottom: 64, // FAB 위의 여백
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x17000000), // 0x17 = 23/255 opacity
                      offset: Offset(0, 6),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0D000000), // 0x0D = 13/255 opacity
                      offset: Offset(0, 13),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMenuItem(
                      path: "assets/image/homemini.svg",
                      label: '자취방 양도하기',
                      onTap: () {
                        // 자취방 양도하기 동작
                        setState(() => _isDialogVisible = false);
                      },
                    ),
                    Divider(height: 1, color: Colors.grey[200]),
                    _buildMenuItem(
                      path: "assets/image/ticket.svg",
                      label: '이용권 양도하기',
                      onTap: () {
                        // 이용권 양도하기 동작
                        setState(() => _isDialogVisible = false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: _isDialogVisible ? BLUE200_COLOR : BLUE400_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_isDialogVisible ? Icons.close : Icons.add, color: Colors.white),
              onPressed: () {
                setState(() => _isDialogVisible = !_isDialogVisible);
              },
            ),
          ),
        ],
      ),
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

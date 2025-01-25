import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:livingalone/chat/view/chat_room_screen.dart';
import 'package:livingalone/chat/view_models/chat_list_provider.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:badges/badges.dart' as badges;
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  String _selectedFilter = '전체';

  @override
  Widget build(BuildContext context) {
    final chatRooms = ref.watch(chatRoomsProvider);
    final filteredRooms = chatRooms.where((room) {
      if (_selectedFilter == '전체') return true;
      if (_selectedFilter == '자취방') return room.type == 'ROOM';
      if (_selectedFilter == '이용권') return room.type == 'TICKET';
      return false;
    }).toList();

    return DefaultLayout(
      title: '',
      showBackButton: false,
      leadingText: true,
      leadingTitle: '채팅',
      appbarBorder: false,
      actions: badges.Badge(
        position: badges.BadgePosition.topEnd(top: -3, end: -3),
        showBadge: true,
        badgeStyle: badges.BadgeStyle(
          badgeColor: BLUE400_COLOR,
        ),
        child: Icon(Icons.notifications,size: 24,color: GRAY400_COLOR,),
      ),
      child: Column(
        children: [
          _buildFilterChips(),
          20.verticalSpace,
          Expanded(
            child: filteredRooms.isEmpty
                ? Center(
                    child: Text(
                      '채팅방이 없습니다.',
                      style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredRooms.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: GRAY100_COLOR,
                    ),
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];
                      return _ChatRoomTile(room: room);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: ['전체', '자취방', '이용권'].map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: FilterChip(
              labelPadding: EdgeInsets.symmetric(horizontal: 6.w),
              label: Text(
                filter,
                style: AppTextStyles.subtitle.copyWith(
                  color: isSelected ? WHITE100_COLOR : GRAY600_COLOR,
                  height: 1
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              backgroundColor: GRAY100_COLOR,
              selectedColor: BLUE400_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.r),
                side: BorderSide(
                  color: Colors.transparent
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChatRoomTile extends ConsumerWidget {
  final ChatRoom room;

  const _ChatRoomTile({
    required this.room,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(room.roomId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: EdgeInsets.only(right: 16.w),
        child: Text(
          '나가기',
          style: AppTextStyles.body1.copyWith(color: Colors.white),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('채팅방 나가기'),
            content: Text('채팅방을 나가시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('나가기'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(chatRoomsProvider.notifier).leaveChatRoom(room.roomId);
      },
      child: InkWell(
        onTap: () {
          pushScreenWithoutNavBar(context, ChatRoomScreen(roomId: room.roomId, opponentName: room.opponentName));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16).w,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: room.opponentProfileUrl.isNotEmpty
                    ? NetworkImage(room.opponentProfileUrl)
                    : null,
                child: room.opponentProfileUrl.isEmpty
                    ? Icon(Icons.person, size: 24.r)
                    : null,
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          room.opponentName,
                          style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        ),
                        8.horizontalSpace,
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 8.w,
                        //     vertical: 2.h,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: BLUE100_COLOR,
                        //     borderRadius: BorderRadius.circular(4.r),
                        //   ),
                        //   child: Text(
                        //     room.type == 'ROOM' ? '자취방' : '이용권',
                        //     style: AppTextStyles.caption2.copyWith(
                        //       color: BLUE400_COLOR
                        //     ),
                        //   ),
                        // ),
                        Expanded(child: Text(room.title, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),)),
                        Text(
                          _formatTime(room.updatedAt),
                          style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    SizedBox(
                      width: 200,
                      child: Text(
                        room.lastMessage,
                        style: AppTextStyles.body1.copyWith(
                          color: room.hasUnreadMessages ? GRAY800_COLOR : GRAY600_COLOR,
                          fontWeight:
                              room.hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    }
    return '방금 전';
  }
}
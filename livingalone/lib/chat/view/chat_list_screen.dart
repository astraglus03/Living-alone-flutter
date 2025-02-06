import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/chat/models/chat_room_model.dart';
import 'package:livingalone/chat/view/chat_room_screen.dart';
import 'package:livingalone/chat/view_models/chat_provider.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
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
    final state = ref.watch(chatRoomProvider);
    final filteredRooms = state.rooms.where((room) {
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
        child: Icon(Icons.notifications, size: 24, color: GRAY400_COLOR,),
      ),
      child: Column(
        children: [
          _buildFilterChips(),
          20.verticalSpace,
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '채팅방을 불러오는데 실패했습니다.',
                              style: AppTextStyles.body1.copyWith(color: ERROR_TEXT_COLOR),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(chatRoomProvider.notifier).loadRooms();
                              },
                              child: Text('다시 시도'),
                            ),
                          ],
                        ),
                      )
                    : filteredRooms.isEmpty
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
      dismissThresholds: const {
        DismissDirection.endToStart: 0.3,
      },
      movementDuration: const Duration(milliseconds: 200),
      resizeDuration: const Duration(milliseconds: 200),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(right: 24.w),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 24.w,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final position = direction == DismissDirection.endToStart ? -1.0 : 1.0;
          if (position <= -0.8) {
            return await _showDeleteDialog(context);
          }
        }
        return false;
      },
      onDismissed: (direction) {
        // TODO: 채팅방 나가기 구현
      },
      child: InkWell(
        onTap: () {
          pushScreenWithoutNavBar(
            context,
            ChatRoomScreen(
              roomId: room.roomId,
              opponentName: room.opponentName,
              opponentProfileUrl: room.opponentProfileUrl,
              chatRoom: room,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16).w,
          child: Row(
            children: [
              CircleAvatar(
                radius: 32.r,
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
                        Expanded(
                          child: Text(
                            room.title,
                            style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        room.lastMessage,
                        style: AppTextStyles.body1.copyWith(
                          color: room.hasUnreadMessages ? GRAY800_COLOR : GRAY600_COLOR,
                          fontWeight: room.hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
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

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '채팅방 나가기',
          style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        ),
        content: Text(
          '채팅방을 나가시겠습니까?',
          style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '취소',
              style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              '나가기',
              style: AppTextStyles.body1.copyWith(color: BLUE400_COLOR),
            ),
          ),
        ],
      ),
    ) ?? false;
  }
}
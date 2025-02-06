import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/options_menu.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/utils/data_utils.dart';
import 'package:livingalone/home/view/living_detail_screen.dart';
import 'package:livingalone/mypage/models/handover_history_model.dart';
import 'package:livingalone/mypage/view_models/handover_history_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/post_modify/view/edit_room_post_screen.dart';
import 'package:livingalone/report/report_screen.dart';

class HandoverHistoryScreen extends ConsumerStatefulWidget {
  const HandoverHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HandoverHistoryScreen> createState() => _HandoverHistoryScreenState();
}

class _HandoverHistoryScreenState extends ConsumerState<HandoverHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentFilter = 'ongoing';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _currentFilter = 'ongoing';
              break;
            case 1:
              _currentFilter = 'completed';
              break;
            case 2:
              _currentFilter = 'hidden';
              break;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(handoverCountProvider);
    final filteredHistory = ref.watch(filteredHandoverHistoryProvider(_currentFilter));
    final historyState = ref.watch(handoverHistoryProvider);

    return DefaultLayout(
      title: '양도 내역',
      appbarBorder: false,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: GRAY800_COLOR,
            labelStyle: AppTextStyles.subtitle,
            unselectedLabelColor: GRAY400_COLOR,
            unselectedLabelStyle: AppTextStyles.subtitle,
            indicatorColor: GRAY800_COLOR,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
            tabs: [
              _buildTab('양도중', counts['ongoing'] ?? 0),
              _buildTab('양도완료', counts['completed'] ?? 0),
              _buildTab('숨김', counts['hidden'] ?? 0),
            ],
          ),
          Expanded(
            child: historyState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  '양도 내역을 불러오는데 실패했습니다.',
                  style: AppTextStyles.body1.copyWith(color: ERROR_TEXT_COLOR),
                ),
              ),
              data: (_) {
                if (filteredHistory.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filteredHistory.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: GRAY200_COLOR,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredHistory[index];
                    return _buildHistoryItem(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = '양도중인 게시글이 없습니다.';
    switch (_currentFilter) {
      case 'completed':
        message = '양도완료된 게시글이 없습니다.';
        break;
      case 'hidden':
        message = '숨김처리된 게시글이 없습니다.';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: GRAY100_COLOR,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.swap_horiz,
              color: GRAY400_COLOR,
              size: 32.w,
            ),
          ),
          16.verticalSpace,
          Text(
            message,
            style: AppTextStyles.body1.copyWith(
              color: GRAY400_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(HandoverHistoryModel history) {
    String getTimeAgo(DateTime dateTime) {
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

    String getSubtitle() {
      if (history.type == PostType.room) {
        if (history.rentType == '전세') {
          final deposit = NumberFormat('#,###').format(history.deposit ?? 0);
          return '${history.rentType} ${deposit}';
        } else {
          final monthlyRent = NumberFormat('#,###').format(history.monthlyRent ?? 0);
          return '월세 ${monthlyRent}';
        }
      } else {
        return history.ticketType ?? '';
      }
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LivingDetailScreen(
              postId: history.itemId,
              postType: history.type,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: GRAY100_COLOR,
                image: history.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(history.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: history.thumbnailUrl == null
                  ? Icon(
                      Icons.image_not_supported,
                      color: GRAY400_COLOR,
                    )
                  : null,
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.title,
                    style: AppTextStyles.body1.copyWith(
                      color: GRAY800_COLOR,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if(history.rentType == RentType.shortRent.label)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: BLUE100_COLOR,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '단기',
                            style: AppTextStyles.caption2.copyWith(
                              color: BLUE400_COLOR,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      if (history.isTransferred)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: GRAY700_COLOR,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '양도완료',
                            style: AppTextStyles.caption2.copyWith(
                              color: WHITE100_COLOR,
                            ),
                          ),
                        ),
                      Text(
                        history.location,
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY600_COLOR,
                        ),
                      ),
                      if(history.type == PostType.room && !history.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(history.type == PostType.room && !history.isTransferred)
                        Text(
                          history.buildingType.toString(),
                          style: AppTextStyles.caption2.copyWith(
                            color: GRAY600_COLOR,
                          ),
                        ),
                      if(history.type == PostType.room && !history.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(history.type == PostType.room && !history.isTransferred)
                        Text(
                          history.propertyType.toString(),
                          style: AppTextStyles.caption2.copyWith(
                            color: GRAY600_COLOR,
                          ),
                        ),
                      if(!history.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(!history.isTransferred)
                        Text(
                          getSubtitle(),
                          style: AppTextStyles.caption2.copyWith(
                            color: GRAY600_COLOR,
                          ),
                        ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      SvgPicture.asset('assets/image/like.svg'),
                      4.horizontalSpace,
                      Text(
                        '${history.viewCount}',
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                      6.horizontalSpace,
                      SvgPicture.asset('assets/image/comment1.svg'),
                      4.horizontalSpace,
                      Text(
                        '${history.commentCount}',
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                      6.horizontalSpace,
                      SvgPicture.asset('assets/image/chat.svg'),
                      4.horizontalSpace,
                      Text(
                        '${history.chatCount}',
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                      6.horizontalSpace,
                      Container(
                        width: 1.w,
                        height: 10.h,
                        color: GRAY400_COLOR,
                      ),
                      6.horizontalSpace,
                      Text(
                        getTimeAgo(history.createdAt),
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                overlayColor: Colors.transparent,
              ),
              onPressed: () {
                _showOptionsMenu(context, history);
              },
              icon: Icon(
                Icons.more_horiz,
                color: GRAY400_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int count) {
    return Tab(
      child: Center(
        child: Text('${text} ${count}'),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, HandoverHistoryModel history) {
    List<OptionMenuItem> options = [];

    if (history.isTransferred) {
      // 양도 완료된 경우
      options = [
        OptionMenuItem(
          text: 'URL 공유하기',
          icon: 'assets/icons/share_nocolor.svg',
          onTap: () {
            DataUtils.sharePost(
              title: '[모양] ${history.type == PostType.room ? '자취방' : '이용권'} 양도 게시물 공유하기',
              price: history.type == PostType.room 
                ? '${history.monthlyRent ?? history.deposit}'
                : '${NumberFormat('#,###').format(history.price ?? 0)}',
              location: history.location,
            );
          },
        ),
        OptionMenuItem(
          text: '게시글 삭제',
          icon: 'assets/icons/delete.svg',
          onTap: () {
            _showDeleteConfirmDialog(context, history.itemId);
          },
        ),
      ];
    } else if (history.isHidden) {
      // 숨김 처리된 경우
      options = [
        OptionMenuItem(
          text: '숨기기 해제',
          icon: 'assets/icons/hide.svg',
          onTap: () {
            // TODO: 숨기기 해제 처리
            ref.read(handoverHistoryProvider.notifier).toggleHidden(history.itemId);
          },
        ),
        OptionMenuItem(
          text: '게시글 수정',
          icon: 'assets/icons/edit.svg',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EditRoomPostScreen(),
              settings: RouteSettings(name: "EditRoomPage"),
            ));
          },
        ),
        OptionMenuItem(
          text: '게시글 삭제',
          icon: 'assets/icons/delete.svg',
          onTap: () {
            Navigator.pop(context);
            _showDeleteConfirmDialog(context, history.itemId);
          },
        ),
      ];
    } else {
      // 양도 중인 경우
      options = [
        OptionMenuItem(
          text: '양도 완료',
          icon: 'assets/image/nothingCheck.svg',
          onTap: () {
            ref.read(handoverHistoryProvider.notifier).completeHandover(history.itemId);
          },
        ),
        OptionMenuItem(
          text: '게시글 수정',
          icon: 'assets/icons/edit.svg',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EditRoomPostScreen(),
              settings: RouteSettings(name: "EditRoomPage"),
            ));
          },
        ),
        OptionMenuItem(
          text: '게시글 숨기기',
          icon: 'assets/icons/hide.svg',
          onTap: () {
            // TODO: 숨기기 처리
            ref.read(handoverHistoryProvider.notifier).toggleHidden(history.itemId);
          },
        ),
        OptionMenuItem(
          text: 'URL 공유하기',
          icon: 'assets/icons/share_nocolor.svg',
          onTap: () {
            DataUtils.sharePost(
              title: '[모양] ${history.type == PostType.room ? '자취방' : '이용권'} 양도 게시물 공유하기',
              price: history.type == PostType.room 
                ? '${history.monthlyRent ?? history.deposit}만원'
                : '${NumberFormat('#,###').format(history.price ?? 0)}원',
              location: history.location,
            );
          },
        ),
        OptionMenuItem(
          text: '게시글 삭제',
          icon: 'assets/icons/delete.svg',
          onTap: () {
            _showDeleteConfirmDialog(context, history.itemId);
          },
        ),
      ];
    }

    OptionsMenu.show(
      context: context,
      options: options,
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '게시글을 삭제하시겠습니까?',
          style: AppTextStyles.title.copyWith(
            color: GRAY800_COLOR,
          ),
        ),
        content: Text(
          '삭제된 게시글은 복구할 수 없습니다.',
          style: AppTextStyles.body2.copyWith(
            color: GRAY600_COLOR,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.body1.copyWith(
                color: GRAY600_COLOR,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(handoverHistoryProvider.notifier).deleteHandoverHistory(itemId);
            },
            child: Text(
              '삭제',
              style: AppTextStyles.body1.copyWith(
                color: ERROR_TEXT_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
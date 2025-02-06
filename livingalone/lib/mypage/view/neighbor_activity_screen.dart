import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/models/neighbor_activity_model.dart';
import 'package:livingalone/mypage/view_models/neighbor_activity_provider.dart';
import 'package:livingalone/neighbor/view/neighbor_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NeighborActivityScreen extends ConsumerStatefulWidget {
  const NeighborActivityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NeighborActivityScreen> createState() => _NeighborActivityScreenState();
}

class _NeighborActivityScreenState extends ConsumerState<NeighborActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentType = 'my';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentType = _tabController.index == 0 ? 'my' : 'participated';
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
    final counts = ref.watch(neighborActivityCountProvider);
    final filteredActivities = ref.watch(filteredNeighborActivityProvider(_currentType));
    final activitiesState = ref.watch(neighborActivityProvider);

    return DefaultLayout(
      title: '이웃소통 활동',
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
              _buildTab('내 게시글', counts['my'] ?? 0),
              _buildTab('참여한 게시글', counts['participated'] ?? 0),
            ],
          ),
          if (activitiesState.isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (activitiesState.hasError)
            Expanded(
              child: Center(
                child: Text(
                  '활동 내역을 불러오는데 실패했습니다.',
                  style: AppTextStyles.body1.copyWith(color: ERROR_TEXT_COLOR),
                ),
              ),
            )
          else if (filteredActivities.isEmpty)
            Expanded(
              child: _buildEmptyState(),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: filteredActivities.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: GRAY200_COLOR,
                ),
                itemBuilder: (context, index) {
                  final activity = filteredActivities[index];
                  return _buildActivityItem(activity);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int count) {
    return Tab(
      child: Center(
        child: Text('$text $count'),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = _currentType == 'my' ? '작성한 게시글이 없습니다.' : '참여한 게시글이 없습니다.';

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
              Icons.people_outline,
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

  Widget _buildActivityItem(NeighborActivityModel activity) {
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

    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => NeighborDetailScreen(id: activity.id),
        //   ),
        // );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      activity.category,
                      style: AppTextStyles.caption2.copyWith(
                        color: BLUE400_COLOR,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    activity.title,
                    style: AppTextStyles.subtitle.copyWith(
                      color: GRAY800_COLOR,
                      fontWeight: FontWeight.w600
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.verticalSpace,
                  Text(
                    activity.content,
                    style: AppTextStyles.caption2.copyWith(
                      color: GRAY600_COLOR,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  12.verticalSpace,
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/image/nothingLike_16.svg',),
                          4.horizontalSpace,
                          Text(
                            '${activity.likeCount}',
                            style: AppTextStyles.caption2.copyWith(
                              color: GRAY400_COLOR,
                            ),
                          ),
                        ],
                      ),
                      6.horizontalSpace,
                      SvgPicture.asset('assets/image/comment1.svg'),
                      6.horizontalSpace,
                      Text(
                        '${activity.commentCount}',
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
                        getTimeAgo(activity.createdAt),
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (activity.thumbnailUrl != null) ...[
              16.horizontalSpace,
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(activity.thumbnailUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
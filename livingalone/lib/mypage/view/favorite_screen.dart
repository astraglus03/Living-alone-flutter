import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/view/living_detail_screen.dart';
import 'package:livingalone/mypage/models/favorite_model.dart';
import 'package:livingalone/mypage/view_models/favorite_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  String _selectedFilter = '전체';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoriteProvider);

    return DefaultLayout(
      title: '관심 목록',
      child: Column(
        children: [
          12.verticalSpace,
          _buildFilterChips(),
          10.verticalSpace,
          if (state.isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (state.error != null)
            Expanded(
              child: Center(
                child: Text(state.error!),
              ),
            )
          else if (state.filteredFavorites.isEmpty)
            Expanded(
              child: _buildEmptyState(),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.filteredFavorites.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: GRAY200_COLOR,
                ),
                itemBuilder: (context, index) {
                  final favorite = state.filteredFavorites[index];
                  return _buildFavoriteItem(favorite);
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
                  fontWeight: FontWeight.w600,
                  height: 1
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                  String? type;
                  if (filter == '자취방') {
                    type = PostType.room.toString();
                  } else if (filter == '이용권') {
                    type = PostType.ticket.toString();
                  }
                  ref.read(favoriteProvider.notifier).getFavorites(type: type);
                }
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

  Widget _buildEmptyState() {
    String message = '관심 목록이 없습니다.';
    if (_selectedFilter == '자취방') {
      message = '관심 있는 자취방이 없습니다.';
    } else if (_selectedFilter == '이용권') {
      message = '관심 있는 이용권이 없습니다.';
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
              Icons.star_border,
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

  Widget _buildFavoriteItem(FavoriteModel favorite) {
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
      if (favorite.type == PostType.room) {
        if (favorite.rentType == RentType.wholeRent.label) {
          final deposit = NumberFormat('#,###').format(favorite.deposit ?? 0);
          return '${favorite.rentType ?? ''} ${deposit}';
        } else {
          final monthlyRent = NumberFormat('#,###').format(favorite.monthlyRent ?? 0);
          return '${'월세'} ${monthlyRent}';
        }
      } else {
        return favorite.ticketType ?? '';
      }
    }

    return InkWell(
      onTap: () {
        // TODO: 상세 페이지로 이동
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LivingDetailScreen(postId: favorite.itemId, postType: favorite.type,),
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
                image: favorite.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(favorite.thumbnailUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: favorite.thumbnailUrl == null
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
                    favorite.title,
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
                      if(favorite.rentType =='단기')
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
                      if (favorite.isTransferred)
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
                        favorite.location,
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY600_COLOR,
                        ),
                      ),
                      if(favorite.type == PostType.room && !favorite.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(favorite.type == PostType.room && !favorite.isTransferred)
                        Text(
                          favorite.buildingType.toString(),
                          style: AppTextStyles.caption2.copyWith(
                            color: GRAY600_COLOR,
                          ),
                        ),
                      if(favorite.type == PostType.room && !favorite.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(favorite.type == PostType.room && !favorite.isTransferred)
                        Text(
                          favorite.propertyType.toString(),
                          style: AppTextStyles.caption2.copyWith(
                            color: GRAY600_COLOR,
                          ),
                        ),
                      if(!favorite.isTransferred)
                        Container(
                          width: 1.w,
                          height: 10.h,
                          color: GRAY400_COLOR,
                        ),
                      if(!favorite.isTransferred)
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
                        '${favorite.viewCount}',
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                      6.horizontalSpace,
                      SvgPicture.asset('assets/image/comment1.svg'),
                      4.horizontalSpace,
                      Text(
                        '${favorite.commentCount}',
                        style: AppTextStyles.caption2.copyWith(
                          color: GRAY400_COLOR,
                        ),
                      ),
                      6.horizontalSpace,
                      SvgPicture.asset('assets/image/chat.svg'),
                      4.horizontalSpace,
                      Text(
                        '${favorite.chatCount}',
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
                        getTimeAgo(favorite.createdAt),
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
                ref.read(favoriteProvider.notifier).toggleFavorite(
                  itemId: favorite.itemId,
                  type: favorite.type.toString(),
                  isFavorite: favorite.isFavorite,
                );
              },
              icon: SvgPicture.asset('assets/image/like_full.svg',
                colorFilter: ColorFilter.mode(
                  favorite.isFavorite ? BLUE400_COLOR : GRAY400_COLOR,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
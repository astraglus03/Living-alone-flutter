import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/colored_image.dart';
import 'package:livingalone/common/component/common_divider.dart';
import 'package:livingalone/common/component/options_menu.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/utils/data_utils.dart';
import 'package:livingalone/neighbor/view_models/post_detail_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:livingalone/home/component/comments_section.dart';
import 'package:livingalone/neighbor/view_models/neighbor_comments_provider.dart';
import 'package:livingalone/neighbor/component/neighbor_comments_section.dart';
import 'package:livingalone/report/report_screen.dart';

class NeighborDetailScreen extends ConsumerWidget {
  final String postId;

  const NeighborDetailScreen({
    required this.postId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postDetailProvider(postId));
    final commentsState = ref.watch(neighborCommentsProvider(postId));
    if (state.isLoading) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return DefaultLayout(
        child: Center(
          child: Text('에러가 발생했습니다: ${state.error}'),
        ),
      );
    }

    final post = state.post;
    if (post == null) {
      return DefaultLayout(
        child: Center(
          child: Text('게시글을 찾을 수 없습니다.'),
        ),
      );
    }

    return DefaultLayout(
      title: '',
      appbarBorder: false,
      actions: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              overlayColor: Colors.transparent,
            ),
            onPressed: () {
              DataUtils.sharePost(title: '커뮤니티 게시글 공유하기', price: '', location: '');
            },
            icon: Icon(Icons.ios_share_outlined),
          ),
          IconButton(
            style: IconButton.styleFrom(
              overlayColor: Colors.transparent,
            ),
            onPressed: () => _showOptionsMenu(context),
            icon: Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24).w,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 72.h,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: GRAY200_COLOR
                            )
                          )
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.network(
                                post.authorProfileUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            12.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.authorName,
                                  style: AppTextStyles.body1.copyWith(
                                    color: GRAY800_COLOR
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  DateFormat('yyyy.MM.dd HH:mm').format(post.createdAt),
                                  style: AppTextStyles.caption2.copyWith(
                                    color: GRAY500_COLOR,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      20.verticalSpace,
                      Container(
                        width:56.w,
                        height: 22.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: BLUE100_COLOR,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          post.topic,
                          style: AppTextStyles.caption2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: BLUE400_COLOR,
                          ),
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        post.title,
                        style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                      ),
                      6.verticalSpace,
                      Text(
                        post.content,
                        style: AppTextStyles.body2.copyWith(color: GRAY700_COLOR),
                      ),
                      if (post.imageUrls.isNotEmpty) ...[
                        12.verticalSpace,
                        ...post.imageUrls.map(
                          (url) => Padding(
                            padding: EdgeInsets.only(bottom: 6.0.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8).r,
                              child: Image.network(
                                url,
                                width: MediaQuery.of(context).size.width,
                                height: 420,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                      6.verticalSpace,
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10).w,
                            decoration: BoxDecoration(
                              color: post.likeCount >0 ? BLUE100_COLOR : GRAY100_COLOR,
                              borderRadius: BorderRadius.circular(20).r,
                            ),
                            child: InkWell(
                              onTap: () {
                                ref.read(postDetailProvider(postId).notifier).toggleLike();
                              },
                              child: Row(
                                children: [
                                  ColoredImage(imagePath: 'assets/image/nothingLike_16.svg', isActive: post.isLiked),
                                  4.horizontalSpace,
                                  Text(
                                    '공감',
                                    style: AppTextStyles.caption2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: post.likeCount >0 ? GRAY700_COLOR : GRAY500_COLOR,
                                    ),
                                  ),
                                  if(post.likeCount >0)
                                  Text(' ${post.likeCount}', style: AppTextStyles.caption2.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: GRAY700_COLOR,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10).w,
                            decoration: BoxDecoration(
                              color: post.likeCount >0 ? BLUE100_COLOR : GRAY100_COLOR,
                              borderRadius: BorderRadius.circular(20).r,
                            ),
                            child: Row(
                              children: [
                                ColoredImage(imagePath: 'assets/image/comment1.svg', isActive: commentsState.totalCommentsCount >0),
                                4.horizontalSpace,
                                Text(
                                  '댓글 ',
                                    style: AppTextStyles.caption2.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: commentsState.totalCommentsCount >0 ? GRAY700_COLOR : GRAY500_COLOR,
                                    ),
                                ),
                                if(commentsState.totalCommentsCount >0)
                                  Text('${commentsState.totalCommentsCount}',style: AppTextStyles.caption2.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: GRAY700_COLOR,
                                  ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      CommonDivider(),
                      NeighborCommentsSection(
                        postId: postId,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    const bool isMyPost = true; // TODO: 실제 게시물 소유자 체크 로직 필요
    final List<OptionMenuItem> options = isMyPost
        ? [
      OptionMenuItem(
        text: '게시글 수정',
        icon: 'assets/icons/edit.svg',
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (_) => EditRoomPostScreen(),
          //   settings: RouteSettings(name: "EditRoomPage"),
          // ));
        },
      ),
      OptionMenuItem(
        text: '게시글 숨기기',
        icon: 'assets/icons/hide.svg',
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ReportScreen(),
          ));
        },
      ),
      OptionMenuItem(
        text: '게시글 삭제',
        icon: 'assets/icons/delete.svg',
        onTap: () {},
      ),
    ]
        : [
      OptionMenuItem(
        text: '신고하기',
        icon: 'assets/icons/report.svg',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ReportScreen()),
          );
        },
      ),
    ];

    OptionsMenu.show(
      context: context,
      options: options,
    );
  }

  // Widget _buildCommentInput() {
  //   return Container(
  //     height: 48.h,
  //     // padding: EdgeInsets.symmetric(horizontal: 12.w),
  //     decoration: BoxDecoration(
  //       color: GRAY100_COLOR,
  //       borderRadius: BorderRadius.circular(10.r),
  //     ),
  //     child: TextFormField(
  //       controller: _messageController,
  //       focusNode: _focusNode,
  //       style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
  //       decoration: InputDecoration(
  //         prefixIcon: IconButton(
  //           icon: Icon(
  //             _showKeyboard ? Icons.add : Icons.close,
  //             color: GRAY600_COLOR,
  //           ),
  //           onPressed: _toggleKeyboard,
  //         ),
  //         suffixIcon: IconButton(
  //           onPressed: (){},
  //           padding: EdgeInsets.zero,
  //           constraints: BoxConstraints(
  //             minWidth: 24.w,
  //             minHeight: 24.h,
  //           ),
  //           style: ButtonStyle(
  //             overlayColor: MaterialStateProperty.all(Colors.transparent),
  //             splashFactory: NoSplash.splashFactory,
  //             mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
  //           ),
  //           icon: Icon(
  //             Icons.arrow_circle_up_rounded,
  //             color: _messageController.text.trim().isEmpty
  //                 ? GRAY400_COLOR
  //                 : BLUE400_COLOR,
  //             size: 24.w,
  //           ),
  //         ),
  //         hintText: '댓글을 입력하세요',
  //         hintStyle: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //           borderRadius: BorderRadius.circular(10.0.r),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0.r),
  //           borderSide: BorderSide.none,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10.0.r),
  //           borderSide: BorderSide.none,
  //         ),
  //         isDense: true,
  //         contentPadding: EdgeInsets.zero,
  //       ),
  //     ),
  //   );
  // }
}

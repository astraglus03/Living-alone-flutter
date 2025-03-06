import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/neighbor/models/neighbor_comment_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/neighbor/view_models/neighbor_comments_provider.dart';

class NeighborCommentsSection extends ConsumerStatefulWidget {
  final String postId;
  
  const NeighborCommentsSection({
    required this.postId,
    super.key,
  });

  @override
  ConsumerState<NeighborCommentsSection> createState() => _NeighborCommentsSectionState();
}

class _NeighborCommentsSectionState extends ConsumerState<NeighborCommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        hasText = _commentController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(neighborCommentsProvider(widget.postId));
    final comments = state.comments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(comments.isEmpty)
          _buildNothingChat(),

        if (comments.isNotEmpty) ...[
          10.verticalSpace,
          ...comments.asMap().entries.map((entry) {
            final index = entry.key;
            final comment = entry.value;
            return _buildCommentItem(comment, index);
          }).toList(),
        ],
        // _buildCommentInput(),
      ],
    );
  }

  Widget _buildNothingChat(){
    return Center(
      child: Column(
        children: [
          163.verticalSpace,
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)).r,
              border: Border.all(color: GRAY200_COLOR),
              color: GRAY100_COLOR,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/image/comment.svg',
              ),
            ),
          ),
          12.verticalSpace,
          Text('첫 댓글을 남겨주세요',style: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),)
        ],
      ),
    );
  }

  Widget _buildCommentItem(NeighborCommentModel comment, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0).w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (comment.isDeleted)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16).r,
                  decoration: BoxDecoration(
                    color: GRAY100_COLOR,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    comment.content,
                    style: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (!comment.isDeleted) ...[
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: Image.network(
                                comment.userProfileUrl ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          Text(
                            comment.username,
                            style: AppTextStyles.body1.copyWith(
                              color: GRAY800_COLOR,
                            ),
                          ),
                          if (comment.isAuthor) ...[
                            6.horizontalSpace,
                            Container(
                              height: 12.h,
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: BLUE400_COLOR,
                                indent: 2,
                                endIndent: 2,
                              ),
                            ),
                            6.horizontalSpace,
                            Text('글쓴이', style: AppTextStyles.body2.copyWith(color: BLUE400_COLOR)),
                          ],
                        ],
                      ],
                    ),
                    if (!comment.isDeleted)
                      Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: GRAY100_COLOR,
                              borderRadius: BorderRadius.all(Radius.circular(4)).r
                            ),
                            child: IconButton(
                              onPressed: () {
                                ref.read(neighborCommentsProvider(widget.postId).notifier).deleteComment(comment.id);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.more_horiz,
                                color: GRAY400_COLOR,
                                size: 20.w,
                              ),
                            ),
                          ),
                          16.horizontalSpace,
                        ],
                      ),
                  ],
                ),
              if (!comment.isDeleted) ...[
                8.verticalSpace,
                SizedBox(
                  width: 281.w,
                  child: Text(
                    comment.content,
                    style: AppTextStyles.body1.copyWith(
                      color: GRAY800_COLOR,
                    ),
                  ),
                ),
                8.verticalSpace,
                Text(
                  comment.time,
                  style: AppTextStyles.caption2.copyWith(
                    color: GRAY400_COLOR,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (comment.replies != null && comment.replies!.isNotEmpty) ...[
          8.horizontalSpace,
          ...comment.replies!.asMap().entries.map((entry) {
            final replyIndex = entry.key;
            final reply = entry.value;
            return _buildReplyItem(reply, index, replyIndex);
          }).toList(),
          16.verticalSpace,
        ],
      ],
    );
  }

  Widget _buildReplyItem(NeighborCommentModel reply, int commentIndex, int replyIndex) {
    final comment = ref.read(neighborCommentsProvider(widget.postId)).comments[commentIndex];
    return Padding(
      padding: const EdgeInsets.only(left: 36).r,
      child: Container(
        padding: EdgeInsets.all(16).r,
        decoration: BoxDecoration(
          color: GRAY100_COLOR,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24).r,
            bottomRight: Radius.circular(24).r,
            topLeft: Radius.circular(3).r,
            topRight: Radius.circular(24).r,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: Image.network(
                          reply.userProfileUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      reply.username,
                      style: AppTextStyles.body1.copyWith(
                        color: GRAY800_COLOR,
                      ),
                    ),
                    if (reply.isAuthor) ...[
                      6.horizontalSpace,
                      Container(
                        height: 12.h,
                        child: VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: BLUE400_COLOR,
                          indent: 2,
                          endIndent: 2,
                        ),
                      ),
                      6.horizontalSpace,
                      Text('글쓴이', style: AppTextStyles.body2.copyWith(color: BLUE400_COLOR)),
                    ],
                  ],
                ),
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                      color: GRAY200_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(4)).r
                  ),
                  child: IconButton(
                    onPressed: () {
                      ref.read(neighborCommentsProvider(widget.postId).notifier)
                          .deleteReply(comment.id, reply.id);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.more_horiz,
                      color: GRAY400_COLOR,
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            SizedBox(
              width: 245.w,
              child: Text(
                reply.content,
                style: AppTextStyles.body2.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
            ),
            8.verticalSpace,
            Text(
              reply.time,
              style: AppTextStyles.caption2.copyWith(
                color: GRAY500_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCommentInput() {
  //   return Container(
  //     height: 48.h,
  //     padding: EdgeInsets.symmetric(horizontal: 12.w),
  //     decoration: BoxDecoration(
  //       color: GRAY100_COLOR,
  //       borderRadius: BorderRadius.circular(10.r),
  //     ),
  //     child: TextFormField(
  //       controller: _commentController,
  //       style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
  //       decoration: InputDecoration(
  //         suffixIcon: IconButton(
  //           onPressed: hasText
  //               ? () {
  //                   ref.read(neighborCommentsProvider(widget.postId).notifier)
  //                       .addComment(_commentController.text);
  //                   _commentController.clear();
  //                   setState(() {
  //                     hasText = false;
  //                     FocusScope.of(context).unfocus();
  //                   });
  //                 }
  //               : null,
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
  //             color: hasText ? BLUE400_COLOR : GRAY400_COLOR,
  //             size: 24.w,
  //           ),
  //         ),
  //         hintText: '댓글을 입력해주세요.',
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
import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/models/comment_model.dart';

class CommentsSection extends StatelessWidget {
  final List<CommentModel>? comments;

  const CommentsSection({
    this.comments,
    super.key,
  });

  int _getTotalCommentsCount() {
    if (comments == null) return 0;
    
    int total = comments!.length;
    
    for (var comment in comments!) {
      if (comment.replies != null) {
        total += comment.replies!.length;
      }
    }
    
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '댓글 ${_getTotalCommentsCount()}',
                style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
              ),
            ],
          ),
          10.verticalSpace,
          _buildCommentInput(),
          if (comments != null && comments!.isNotEmpty) ...[
            10.verticalSpace,
            ...comments!.map((comment) => _buildCommentItem(comment)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: GRAY100_COLOR,
        borderRadius: BorderRadius.circular(2.r),
        // border: Border.all(
        //   color: GRAY100_COLOR,
        //   width: 1,
        // ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '댓글을 입력해주세요.',
              style: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
            ),
          ),
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: Icon(
              Icons.arrow_circle_up_sharp,
              color: GRAY400_COLOR,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16).r,
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
                      color: GRAY200_COLOR,
                      borderRadius: BorderRadius.circular(4.r),
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
                    SizedBox(
                      height: 6.h,  // 선의 높이 지정
                      child: VerticalDivider(
                        width: 1,    // 선의 너비
                        thickness: 1,  // 선의 두께
                        color: BLUE400_COLOR,
                      ),
                    ),
                    6.horizontalSpace,
                    Text('글쓴이',style: AppTextStyles.body2.copyWith(color: BLUE400_COLOR),)
                  ],
                ],
              ),
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: GRAY100_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(4)).r
                ),
                child: IconButton(
                  onPressed: () {},
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
          Text(
            comment.content,
            style: AppTextStyles.body1.copyWith(
              color: GRAY800_COLOR,
            ),
          ),
          8.verticalSpace,
          Text(
            comment.time,
            style: AppTextStyles.caption2.copyWith(
              color: GRAY400_COLOR,
            ),
          ),
          if (comment.replies != null && comment.replies!.isNotEmpty) ...[
            16.verticalSpace,
            ...comment.replies!.map((reply) => _buildReplyItem(reply)),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(CommentModel reply) {
    return Padding(
      padding: EdgeInsets.only(left: 36.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.horizontalSpace,
          Expanded(
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
                            color: GRAY200_COLOR,
                            borderRadius: BorderRadius.circular(4.r),
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
                          VerticalDivider(
                            width: 6,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Text('글쓴이',style: AppTextStyles.body2.copyWith(color: BLUE400_COLOR),)
                        ],
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.more_horiz,
                        color: GRAY400_COLOR,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text(
                  reply.content,
                  style: AppTextStyles.body2.copyWith(
                    color: GRAY800_COLOR,
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
        ],
      ),
    );
  }
}



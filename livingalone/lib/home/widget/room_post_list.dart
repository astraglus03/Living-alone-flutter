import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';
import '../models/post_tile_model.dart';
import '../view_models/room_post_tile.dart';

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}초 전';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}일 전';
  } else {
    final months = difference.inDays ~/ 30;
    if (months < 12) {
      return '${months}개월 전';
    } else {
      final years = months ~/ 12;
      return '${years}년 전';
    }
  }
}

class PostList extends ConsumerStatefulWidget {
  final List<Post> posts;

  PostList({required this.posts});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        ref.read(postProvider.notifier).loadPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        final post = widget.posts[index];
        return PostItem(post: post);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class PostItem extends StatelessWidget {
  final Post post;
  PostItem({required this.post});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    post.thumbnailUrl,
                    width: 80,  // 원하는 크기로 조정 가능
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR)),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                            decoration: BoxDecoration(
                              color: GRAY700_COLOR, // 배경색
                              borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                            ),
                            child: Text(
                              post.subTitle1,
                              style: AppTextStyles.caption2.copyWith(
                                color: WHITE100_COLOR,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                            decoration: BoxDecoration(
                              color: BLUE200_COLOR, // 배경색
                              borderRadius: BorderRadius.circular(4), // 모서리 둥글게
                            ),
                            child: Text(
                              post.subTitle2,
                              style: AppTextStyles.caption2.copyWith(
                                color: BLUE400_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text(post.subTitle3, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                          SizedBox(
                            height: 6,
                            child: VerticalDivider(
                              thickness: 1,
                              width: 8,
                              color: GRAY400_COLOR,
                            ),
                          ),
                          Text(post.subTitle4, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                          SizedBox(
                            height: 6,
                            child: VerticalDivider(
                              thickness: 1,
                              width: 8,
                              color: GRAY400_COLOR,
                            ),
                          ),
                          Text(post.subTitle5, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/like.svg'),
                              SizedBox(width: 2),
                              Text('${post.likes}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                            ],
                          ),
                          SizedBox(width: 6),
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/comment.svg'),
                              SizedBox(width: 2),
                              Text('${post.comments}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                            ],
                          ),
                          SizedBox(width: 6),
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/chat.svg'),
                              SizedBox(width: 2),
                              Text('${post.scraps}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                            child: VerticalDivider(
                              thickness: 1,
                              width: 12,
                              color: GRAY400_COLOR,
                            ),
                          ),
                          Text('${timeAgo(post.createdAt)}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DottedLine(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            lineLength: MediaQuery.of(context).size.width * 0.87,
            lineThickness: 1.0,
          )
        ],
      ),
    );
  }
}
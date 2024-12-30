import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livingalone/common/const/colors.dart';
import '../models/post_tile_model.dart';
import '../view_models/post_tile.dart';
import 'package:dotted_line/dotted_line.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
      ),
      body: postsState.when(
        data: (posts) => PostList(posts: posts),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

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
      width: MediaQuery.of(context).size.width* 0.92,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            minVerticalPadding: 16,
            leading: Image.network(post.thumbnailUrl, width: 80, height: 80),
            title: Text(post.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(post.subTitle1),
                    SizedBox(
                      width: 6,
                    ),
                    Text(post.subTitle2),
                    SizedBox(
                      height: 6,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 8,
                        color: GRAY400_COLOR,
                      ),
                    ),
                    Text(post.subTitle3),
                    SizedBox(
                      height: 6,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 8,
                        color: GRAY400_COLOR,
                      ),
                    ),
                    Text(post.subTitle4),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/image/like.svg'),
                        SizedBox(
                          width: 2,
                        ),
                        Text('${post.likes}'),
                      ],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/image/comment.svg'),
                        SizedBox(
                          width: 2,
                        ),
                        Text('${post.comments}'),
                      ],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/image/chat.svg'),
                        SizedBox(
                          width: 2,
                        ),
                        Text('${post.scraps}'),
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
                    Text('${timeAgo(post.createdAt)}'),
                  ],
                ),
              ],
            ),
          ),
          DottedLine(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            lineLength: MediaQuery.of(context).size.width* 0.92,
            lineThickness: 1.0,
          )
        ],
      ),
    );
  }
}

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/home/models/ticket_post_model.dart';
import 'package:livingalone/home/view_models/ticket_post_provider.dart';
import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';


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

class TicketPostList extends ConsumerStatefulWidget {
  final List<TicketPost> ticketposts;

  TicketPostList({required this.ticketposts});

  @override
  _TicketPostListState createState() => _TicketPostListState();
}

class _TicketPostListState extends ConsumerState<TicketPostList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        ref.read(ticketPostProvider.notifier).loadPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.ticketposts.length,
      itemBuilder: (context, index) {
        final ticketpost = widget.ticketposts[index];
        return TicketPostItem(ticketpost: ticketpost);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TicketPostItem extends StatelessWidget {
  final TicketPost ticketpost;
  TicketPostItem({required this.ticketpost});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticketpost.title, style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR)),
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
                              ticketpost.subTitle1,
                              style: AppTextStyles.caption2.copyWith(
                                color: WHITE100_COLOR,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(ticketpost.subTitle2, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                          SizedBox(
                            height: 6,
                            child: VerticalDivider(
                              thickness: 1,
                              width: 8,
                              color: GRAY400_COLOR,
                            ),
                          ),
                          Text(ticketpost.subTitle3, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                          SizedBox(
                            height: 6,
                            child: VerticalDivider(
                              thickness: 1,
                              width: 8,
                              color: GRAY400_COLOR,
                            ),
                          ),
                          Text(ticketpost.subTitle4, style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR)),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/like.svg'),
                              SizedBox(width: 2),
                              Text('${ticketpost.likes}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                            ],
                          ),
                          SizedBox(width: 6),
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/comment1.svg'),
                              SizedBox(width: 2),
                              Text('${ticketpost.comments}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
                            ],
                          ),
                          SizedBox(width: 6),
                          Row(
                            children: [
                              SvgPicture.asset('assets/image/chat.svg'),
                              SizedBox(width: 2),
                              Text('${ticketpost.scraps}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
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
                          Text('${timeAgo(ticketpost.createdAt)}', style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR)),
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/home/component/post_type.dart';
import 'package:ticket_clippers/ticket_clippers.dart';
import 'package:dotted_line/dotted_line.dart';

class RentInfoCard extends StatelessWidget {
  final PostType postType; // 티켓 카드
  final int leftFee; // 왼쪽 가격 or 횟수
  final int rightFee; // 관리비 가격 or 양도비 가격

  const RentInfoCard({
    required this.postType,
    required this.leftFee,
    required this.rightFee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipPath(
          clipper: TicketRoundedEdgeClipper(
            edge: Edge.left,
            position: 45,
            radius: 20,
          ),
          child: Container(
            width: 172.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: BLUE100_COLOR,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ).r,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  postType == PostType.room ? '월세' : '남은 횟수',
                  style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                ),
                6.verticalSpace,
                Text(
                  '$leftFee ${postType == PostType.room ? '만원' : '회'}',
                  style: AppTextStyles.title.copyWith(color: BLUE400_COLOR),
                ),
              ],
            ),
          ),
        ),
        ClipPath(
          clipper: TicketRoundedEdgeClipper(
            edge: Edge.right,
            position: 50,
            radius: 20,
          ),
          child: Container(
            width: 173.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: BLUE100_COLOR,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ).r,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DottedLine(
                  direction: Axis.vertical,
                  lineLength: 45,
                  dashLength: 2.5,
                  dashColor: BLUE300_COLOR,
                  lineThickness: 2,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        postType == PostType.room ? '관리비' : '양도비',
                        style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                      ),
                      6.verticalSpace,
                      Text(
                        '$rightFee 만원',
                        style: AppTextStyles.title.copyWith(color: BLUE400_COLOR),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
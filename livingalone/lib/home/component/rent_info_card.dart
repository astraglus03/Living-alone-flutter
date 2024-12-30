import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:ticket_clippers/ticket_clippers.dart';
import 'package:dotted_line/dotted_line.dart';

class RentInfoCard extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final int leftFee;
  final int rightFee;
  final String subFeeOrTimes;

  const RentInfoCard(
      {super.key,
      required this.leftTitle,
      required this.rightTitle,
      required this.leftFee,
      required this.rightFee,
      required this.subFeeOrTimes});

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
            // padding: EdgeInsets.only(left: 53,top: 18).r,
            decoration: BoxDecoration(
              color: BLUE100_COLOR,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12),).r
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  leftTitle,
                  style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                ),
                6.verticalSpace,
                Text(
                  '$leftFee $subFeeOrTimes',
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
            // padding: EdgeInsets.only(left: 53,top: 18).r,
            decoration: BoxDecoration(
              color: BLUE100_COLOR,
              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12),).r
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
                        rightTitle,
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
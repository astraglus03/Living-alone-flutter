import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/report/report_detail_screen.dart';

class ReportPostmanScreen extends StatelessWidget {
  ReportPostmanScreen({super.key});

  final List<String> reportReasons = [
    '비매너 사용자에요',
    '욕설 및 비하 표현을 해요',
    '부적절한 대화 및 만남을 시도해요',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '작성자 신고하기',
      showCloseButton: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 24).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              '게시글을 신고하는 이유를 선택해 주세요',
              style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
            ),
            20.verticalSpace,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportReasons.length,
              separatorBuilder: (context, index) => Divider(
                color: GRAY200_COLOR,
                height: 1.h,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    reportReasons[index],
                    style:AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: GRAY300_COLOR,
                    size: 16.w,
                  ),
                  onTap: () {
                    // TODO: 신고 사유 선택 시 처리
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ReportDetailScreen(reason: reportReasons[index],)));
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

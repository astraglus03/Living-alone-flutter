import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/component/inform_common_inquiry.dart';
import 'package:livingalone/mypage/models/faq_model.dart';

class FAQDetailScreen extends ConsumerWidget {
  final FAQModel faq;

  const FAQDetailScreen({
    required this.faq,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '문의하기',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q. ${faq.question}',
                style: AppTextStyles.subtitle.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 20),
                child: Text(
                  faq.answer,
                  style: AppTextStyles.body1.copyWith(
                    color: GRAY800_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InformCommonInquiry(),
            ],
          ),
        ),
      ),
    );
  }
}
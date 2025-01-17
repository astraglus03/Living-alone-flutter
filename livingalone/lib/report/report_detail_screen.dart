import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class ReportDetailScreen extends StatefulWidget {
  static String get routeName => 'reportDetail';
  final String reason;

  const ReportDetailScreen({
    required this.reason,
    super.key,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool showError = false;
  bool hasContent = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_onTextChanged);
    _contentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newHasContent = _contentController.text.trim().isNotEmpty;
    if (hasContent != newHasContent) {
      setState(() {
        hasContent = newHasContent;
      });
    }
  }

  void _validateAndSubmit() {
    if (_contentController.text.trim().isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }

    // TODO: 신고 내용 제출 로직 구현
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시글 신고하기',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      '신고 유형',
                      style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                    ),
                    8.verticalSpace,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: GRAY200_COLOR,)
                      ),
                      child: Text(
                        widget.reason,
                        style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      '상세 내용',
                      style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                    ),
                    8.verticalSpace,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        minHeight: 180.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: GRAY200_COLOR)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12).w,
                      child: TextField(
                        style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        controller: _contentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '신고 내용을 자세히 작성해 주세요.',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                            color: GRAY400_COLOR,
                          ),
                        ),
                        onChanged: (value) {
                          if (showError && value.trim().isNotEmpty) {
                            setState(() {
                              showError = false;
                            });
                          }
                        },
                      ),
                    ),
                    if (showError)
                      const ShowErrorText(errorText: '신고 내용을 입력해 주세요'),
                  ],
                ),
              ),
            ),
          ),
          CustomBottomButton(
            backgroundColor: _contentController.text.isNotEmpty ? BLUE400_COLOR : GRAY200_COLOR,
            foregroundColor: _contentController.text.isNotEmpty ? WHITE100_COLOR: GRAY800_COLOR,
            appbarBorder: false,
            text: '신고하기',
            textStyle: AppTextStyles.title,
            onTap: _validateAndSubmit,
          )
        ],
      ),
    );
  }
}
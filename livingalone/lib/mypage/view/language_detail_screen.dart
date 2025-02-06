import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/language_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/view_models/mypage_provider.dart';

class LanguageDetailScreen extends ConsumerStatefulWidget {
  const LanguageDetailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageDetailScreen> createState() => _LanguageDetailScreenState();
}

class _LanguageDetailScreenState extends ConsumerState<LanguageDetailScreen> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    selectedLanguage = ref.read(myPageProvider).profile!.language;
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(myPageProvider);

    return DefaultLayout(
      title: '언어 설정',
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Text(
                    '모양에서 사용할 언어를\n선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomSelectList(
                    items: Language.values.map((e) => e.label).toList(),
                    selected: selectedLanguage,
                    onItemSelected: (language) {
                      setState(() {
                        selectedLanguage = language;
                      });
                    },
                    showError: false,
                    multiSelect: false,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedLanguage != null && 
                      selectedLanguage != currentLanguage.profile!.language) {
                    ref.read(myPageProvider.notifier).updateLanguage(selectedLanguage!);
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BLUE400_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  '확인',
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
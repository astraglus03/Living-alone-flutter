import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/language_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view_models/language_setting_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageDetailScreen extends ConsumerWidget {
  const LanguageDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageSettingProvider);

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
                    '모앱에서 사용할 언어를\n선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomSelectList(
                    items: Language.values.map((e) => e.label).toList(),
                    selected: currentLanguage,
                    onItemSelected: (language) {
                      ref.read(languageSettingProvider.notifier).setLanguage(language);
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
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BLUE400_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
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
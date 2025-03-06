import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/language_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

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
    
    // 유저 정보에서 초기 언어 설정값 가져오기
    final userState = ref.read(userMeProvider);
    if (userState is UserModel) {
      selectedLanguage = userState.language;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);

    if (userState is UserModelLoading) {
      return const DefaultLayout(
        title: '언어 설정',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (userState is UserModelError) {
      return DefaultLayout(
        title: '언어 설정',
        child: Center(
          child: Text('설정을 불러올 수 없습니다: ${userState.message}'),
        ),
      );
    }
    
    final userModel = userState as UserModel;
    
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
                      selectedLanguage != userModel.language) {
                    // 언어 설정 업데이트
                    ref.read(userMeProvider.notifier).updateLanguage(selectedLanguage!);
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
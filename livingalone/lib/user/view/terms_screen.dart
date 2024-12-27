import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/view/signup_screen.dart';
import 'package:livingalone/user/view/terms_detail_screen.dart';

class TermsScreen extends StatelessWidget {
  static String get routeName => 'terms';

  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용동의',
      isFirstScreen: true,
      child: Stack(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.fromLTRB(24, 60, 0, 0),
            child: Column(
              children: [
                Container(
                  width: 345,
                  height: 56,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: GRAY100_COLOR,
                    borderRadius: BorderRadius.circular(12.0),
                    border: const Border(
                      bottom: BorderSide(
                        color: GRAY200_COLOR,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/nothingCheck.png'),
                      const SizedBox(width: 12,),
                      const Text(
                        '전체 동의하기',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 345,
                  height: 56,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        // 기본적으로 Row에도 길이가 존재하여 피그마대로 진행할경우 overflow 발생함. 최적은 265
                        width: 265,
                        height: 24,
                        child: Row(
                          children: [
                            Image.asset('assets/image/nothingCheck.png'),
                            const SizedBox(width: 12,),
                            const Text(
                              '[필수]개인정보 수집 및 이용 동의',
                              style: AppTextStyles.subtitle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8,),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => TermsDetailScreen()));
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                          maxWidth: 24,
                          maxHeight: 24,
                        ),
                        icon: Image.asset(
                          'assets/image/right_24.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            backgroundColor: GRAY200_COLOR,
            foregroundColor: GRAY800_COLOR, // 택스트 색상
            text: '다음',
            textStyle: AppTextStyles.title,
            onTap: () {
              // TODO: 나중에 go router 적용할 것. 임시로 넣어둠.
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignupScreen()));
            },
          ),
        ],
      ),
    );
  }
}

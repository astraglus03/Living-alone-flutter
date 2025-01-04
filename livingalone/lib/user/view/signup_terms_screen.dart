import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_terms_item.dart';

class SignupTermsScreen extends StatefulWidget {
  static String get routeName => 'terms';

  const SignupTermsScreen({super.key});

  @override
  State<SignupTermsScreen> createState() => _SignupTermsScreenState();
}

class _SignupTermsScreenState extends State<SignupTermsScreen> {
  bool firstAgreedSelected = false;
  bool secondAgreedSelected = false;

  void _navigateToTermsDetail(bool isFirst) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignupTermsDetailScreen(
          onRead: (agreed) {
            setState(() {
              if (isFirst) {
                firstAgreedSelected = agreed;
              } else {
                secondAgreedSelected = agreed;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용동의',
      showBackButton: false,
      currentStep: 1,
      totalSteps: 4,
      backgroundColor: WHITE100_COLOR,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.fromLTRB(24, 48, 24, 0).r,
              child: Column(
                children: [
                  CustomTermsItem(
                    isSelected: firstAgreedSelected,
                    onIconTap: () => _navigateToTermsDetail(true),
                    title: '[필수]개인정보 수집 및 이용 동의',
                    onAgreeChanged: () {
                      setState(() {
                        firstAgreedSelected = !firstAgreedSelected;
                      });
                    },
                  ),
                  10.verticalSpace,
                  CustomTermsItem(
                    isSelected: secondAgreedSelected,
                    onIconTap: () => _navigateToTermsDetail(false),
                    title: '[필수]개인정보 수집 및 이용 동의',
                    onAgreeChanged: () {
                      setState(() {
                        secondAgreedSelected = !secondAgreedSelected;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            backgroundColor: BLUE400_COLOR,
            foregroundColor: WHITE100_COLOR,
            disabledBackgroundColor: GRAY200_COLOR,
            disabledForegroundColor: GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            isEnabled: secondAgreedSelected && firstAgreedSelected,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SignupAuthenticationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

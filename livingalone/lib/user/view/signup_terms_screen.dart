import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/component/agree_container.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_terms_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/view_models/signup_provider.dart';

class SignupTermsScreen extends ConsumerStatefulWidget {
  static String get routeName => 'terms';

  const SignupTermsScreen({super.key});

  @override
  ConsumerState<SignupTermsScreen> createState() => _SignupTermsScreenState();
}

class _SignupTermsScreenState extends ConsumerState<SignupTermsScreen> {
  void _navigateToTermsDetail(bool isFirst) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignupTermsDetailScreen(
          isFirstTerms: isFirst,
          onAgree: (agreed) {
            if (isFirst) {
              ref.read(signupProvider.notifier).setPrivacyAgreement(agreed);
            } else {
              ref.read(signupProvider.notifier).setTermsAgreement(agreed);
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider.notifier);
    final termsAgreed = signupState.isTermsAgreed;
    final privacyAgreed = signupState.isPrivacyAgreed;
    final alarmAgreed = signupState.isAlarmAgreed;

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
                    isSelected: privacyAgreed,
                    onIconTap: () => _navigateToTermsDetail(true),
                    title: '[필수]개인정보 수집 및 이용 동의',
                    onAgreeChanged: () {
                      ref.read(signupProvider.notifier).setPrivacyAgreement(!privacyAgreed);
                      setState(() {});
                    },
                  ),
                  10.verticalSpace,
                  CustomTermsItem(
                    isSelected: termsAgreed,
                    onIconTap: () => _navigateToTermsDetail(false),
                    title: '[필수]서비스 이용약관',
                    onAgreeChanged: () {
                      ref.read(signupProvider.notifier).setTermsAgreement(!termsAgreed);
                      setState(() {});
                    },
                  ),
                  10.verticalSpace,
                  AgreeContainer(
                    text: '[선택] 서비스 알림 수신 동의',
                    isSelected: alarmAgreed,
                    lineColor: BLUE200_COLOR,
                    onTap: () {
                      ref.read(signupProvider.notifier).setAlarmAgreement(!alarmAgreed);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            appbarBorder: false,
            backgroundColor: BLUE400_COLOR,
            foregroundColor: WHITE100_COLOR,
            disabledBackgroundColor: GRAY200_COLOR,
            disabledForegroundColor: GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            isEnabled: signupState.isAllTermsAgreed,
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

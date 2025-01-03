import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:livingalone/user/view/signup_complete_screen.dart';

class SignupNicknameScreen extends StatefulWidget {
  static String get routeName => 'nickname';
  const SignupNicknameScreen({super.key});

  @override
  State createState() => _SignupNicknameScreenState();
}

class _SignupNicknameScreenState extends State {
  final TextEditingController nicknameController = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode nicknameFocus = FocusNode();
  bool isDuplicateChecked = false;
  bool isDuplicateValid = false;
  String? errorMessage;

  @override
  void dispose() {
    nicknameController.dispose();
    nicknameFocus.dispose();
    super.dispose();
  }

  void checkNicknameDuplicate() {
    final nickname = nicknameController.text;
    
    if (nickname.isEmpty) {
      setState(() {
        errorMessage = '닉네임을 입력해주세요';
        isDuplicateChecked = false;
        isDuplicateValid = false;
      });
      return;
    }
    
    if (!isValidNickname(nickname)) {
      setState(() {
        errorMessage = '한글, 영어, 숫자 조합으로 2~8자로 입력해주세요';
        isDuplicateChecked = false;
        isDuplicateValid = false;
      });
      return;
    }
    
    // TODO: 임의로 duplicate는 중복 되도록 설정. api를 통해 중복확인 수정 필요.
    setState(() {
      isDuplicateChecked = true;
      isDuplicateValid = nickname != "duplicate";
      if (!isDuplicateValid) {
        errorMessage = '이미 사용중인 닉네임입니다';
      } else {
        errorMessage = null;
      }
    });
  }

  bool isValidNickname(String nickname) {
    final nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9]{2,8}$');
    return nicknameRegex.hasMatch(nickname);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      currentStep: 4,
      totalSteps: 4,
      title: '회원가입',
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              controller: _scrollController,
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text('모양에서 사용할\n닉네임을 입력해주세요', style: AppTextStyles.heading1,),
                    40.verticalSpace,
                    CustomSignupField(
                      controller: nicknameController,
                      focusNode: nicknameFocus,
                      hintText: '2~8자 입력(한글, 영어, 숫자 가능)',
                      type: TextInputType.text,
                      subTitle: '닉네임',
                      submitButtonTitle: '중복확인',
                      width: 74.w,
                      onPressed: () {
                        nicknameController.clear();
                        setState(() {
                          errorMessage = null;
                          isDuplicateChecked = false;
                          isDuplicateValid = false;
                        });
                      },
                      errorText: errorMessage,
                      onTap: checkNicknameDuplicate,
                      buttonBackground: BLUE100_COLOR,
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomButton(
            backgroundColor: isDuplicateChecked && isDuplicateValid ? BLUE400_COLOR : GRAY200_COLOR,
            foregroundColor: isDuplicateChecked && isDuplicateValid ? WHITE100_COLOR : GRAY800_COLOR,
            text: '가입하기',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (isDuplicateChecked && isDuplicateValid) {
                // TODO: 페이지 라우팅
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => SignupCompleteScreen()),
                      (route) => false,
                );
              } else {
                setState(() {
                  errorMessage = '닉네임 중복 확인을 완료해주세요';
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

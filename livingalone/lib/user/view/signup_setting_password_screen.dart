import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/view/signup_nickname_screen.dart';

class SignupSettingPasswordScreen extends StatefulWidget {
  static String get routeName => 'setPw';
  const SignupSettingPasswordScreen({super.key});

  @override
  _SignupSettingPasswordScreenState createState() => _SignupSettingPasswordScreenState();
}

class _SignupSettingPasswordScreenState extends State<SignupSettingPasswordScreen> {
  final TextEditingController mobileNumController = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode passwordFocus = FocusNode();
  bool isLooking = true;
  bool isPwValid = false;
  String? errorMessage;

  @override
  void dispose() {
    mobileNumController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      setState(() {
        errorMessage = '비밀번호를 입력해주세요';
        isPwValid = false;
      });
      return;
    }

    if (password.length < 6 || !RegExp(r'[a-zA-Z]').hasMatch(password) || !RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        errorMessage = '영문과 숫자를 조합하여 6자 이상 입력해주세요';
        isPwValid = false;
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isPwValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      currentStep: 3,
      totalSteps: 4,
      title: '회원가입',
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: _scrollController,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text('비밀번호를 설정해주세요', style: AppTextStyles.heading1,),
                      40.verticalSpace,
                      CustomSignupField(
                        controller: mobileNumController,
                        focusNode: passwordFocus,
                        hintText: '6자 이상 입력(영문+숫자)',
                        obscureText: isLooking,
                        type: TextInputType.visiblePassword,
                        // validateText: '6자 이상의 비밀번호를',
                        subTitle: '비밀번호',
                        submitButtonTitle: isLooking ? '비밀번호 보기' : '비밀번호 숨기기',
                        onPressed: (){
                          mobileNumController.clear();
                          setState(() {
                            isPwValid = false;
                          });
                        },
                        // FIXME: 피그마 101 113
                        width: isLooking ? 105.w : 117.w,
                        errorText: errorMessage,
                        onChanged: (value) {
                          validatePassword(value);
                        },
                        onTap: () {
                          setState(() {
                            isLooking = !isLooking;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomBottomButton(
            backgroundColor: isPwValid ? BLUE400_COLOR : GRAY200_COLOR,
            foregroundColor: isPwValid ? WHITE100_COLOR : GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (isPwValid) {
                //TODO: 페이지 라우팅 부분
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SignupNicknameScreen()));
              } else {
                validatePassword(mobileNumController.text);
              }
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedesignPasswordScreen extends StatefulWidget {
  static String get routeName => 'resetPw';

  const RedesignPasswordScreen({super.key});

  @override
  _RedesignPasswordScreenState createState() => _RedesignPasswordScreenState();
}

class _RedesignPasswordScreenState extends State<RedesignPasswordScreen> {
  final TextEditingController mobileNumController = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode passwordFocus = FocusNode();
  bool isLooking = false;
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

    if (password.length < 6 ||
        !RegExp(r'[a-zA-Z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
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
      backgroundColor: BLUE100_COLOR,
      appbarTitleBackgroundColor: BLUE100_COLOR,
      appbarBorderColor: BLUE200_COLOR,
      title: '비밀번호 찾기',
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
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    26.verticalSpace,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '비밀번호를 재설정해 주세요',
                        style: AppTextStyles.title,
                      ),
                    ),
                    20.verticalSpace,
                    CustomSignupField(
                      controller: mobileNumController,
                      focusNode: passwordFocus,
                      hintText: '6자 이상 입력(영문+숫자)',
                      obscureText: isLooking,
                      type: TextInputType.visiblePassword,
                      // validateText: '6자 이상의 비밀번호를',
                      subTitle: '비밀번호',
                      submitButtonTitle: isLooking ? '비밀번호 보기' : '비밀번호 숨기기',
                      buttonBackground: WHITE100_COLOR,
                      formFieldBackground: WHITE100_COLOR,
                      onPressed: (){
                        mobileNumController.clear();
                        setState(() {
                          isPwValid = false;
                        });
                      },
                      // FIXME: 피그마 101 113
                      width: isLooking ? 102.w : 114.w,
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
          CustomButton(
            backgroundColor: isPwValid ? BLUE400_COLOR : WHITE100_COLOR,
            foregroundColor: isPwValid ? WHITE100_COLOR : GRAY400_COLOR,
            text: '완료',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (isPwValid) {
                //TODO: 페이지 라우팅 부분
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

import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPasswordScreen extends StatefulWidget {
  const SettingPasswordScreen({super.key});

  @override
  _SettingPasswordScreenState createState() => _SettingPasswordScreenState();
}

class _SettingPasswordScreenState extends State<SettingPasswordScreen> {
  final TextEditingController mobileNumController = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLooking = false;

  @override
  void dispose() {
    mobileNumController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  bool isPasswordValid() {
    return mobileNumController.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      actionString: '3',
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
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height-100,
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
                        hintText: '6자 이상의 비밀번호를 입력해주세요',
                        obscureText: isLooking,
                        type: TextInputType.visiblePassword,
                        validateText: '6자 이상의 비밀번호를',
                        subTitle: '비밀번호',
                        submitButtonTitle: isLooking ? '비밀번호 보기' : '비밀번호 숨기기',
                        onPressed: mobileNumController.clear,
                        // FIXME: 피그마 101 113
                        width: isLooking ? 102.w : 114.w,
                        onTap: () {
                          setState(() {
                            isLooking = !isLooking;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          if (value.length < 6) {
                            return '비밀번호는 6자 이상이어야 합니다.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomButton(
            backgroundColor: isPasswordValid() ? BLUE400_COLOR : GRAY200_COLOR,
            foregroundColor: isPasswordValid() ? WHITE100_COLOR : GRAY800_COLOR,
            text: isPasswordValid() ? '가입하기' : '다음',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // TODO: 유효성 검사 처리 로직
              }
            },
          ),
        ],
      ),
    );
  }
}

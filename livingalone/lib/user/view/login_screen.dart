import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:livingalone/common/component/custom_input_field.dart';
import 'package:livingalone/common/component/find_signup_button.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/view/terms_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: BLUE100_COLOR,
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(24, 492, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('회원 로그인', style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),),
            SizedBox(height: 16,),
            CustomInputField(
                controller: idController,
                hintText: '학교 이메일을 입력해 주세요',
                obscureText: false),
            SizedBox(height: 12,),
            CustomInputField(
                controller: pwController,
                hintText: '비밀번호를 입력해 주세요',
                obscureText: true),
            // Container(
            //   width: 148,
            //   height: 40,
            //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //   decoration: BoxDecoration(
            //     borderRadius:
            //   ),
            // )
            Container(
              width: 345,
              height: 40,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isChecked ? BLUE300_COLOR : BLUE300_COLOR,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: WHITE100_COLOR,
                      ),
                      child: _isChecked
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: BLUE300_COLOR,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 11),
                    Text(
                      '간편로그인 정보 저장',
                      style: AppTextStyles.body1.copyWith(color: BLUE400_COLOR),
                    ),
                  ],
                ),
              ),
            ),
            CommonButton(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: BLUE400_COLOR,
                    foregroundColor: WHITE100_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                onPressed: () {
                  // TODO: go router 나중에 적용하기.
                },
                child: Text('로그인', style: AppTextStyles.title),
              ),
            ),
            SizedBox(height: 12.0,),
            Container(
              width: 345,
              height: 36,
              child: Row(
                children: [
                  FindSignupButton(
                      onTap: () {
                        // TODO: 비밀번호 찾기 페이지 라우팅
                      },
                      text: '비밀번호 찾기'
                  ),
                  SizedBox(width: 9,),
                  FindSignupButton(
                      onTap: () {
                        // TODO: 회원가입 페이지 라우팅
                      },
                      text: '회원가입'
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

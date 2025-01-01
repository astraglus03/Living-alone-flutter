import 'package:flutter/material.dart';
import 'package:livingalone/common/component/colored_image.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_input_field.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindPasswordAuthScreen extends StatefulWidget {
  static String get routeName => 'findPwAuth';

  const FindPasswordAuthScreen({super.key});

  @override
  State<FindPasswordAuthScreen> createState() => _FindPasswordAuthScreenState();
}

class _FindPasswordAuthScreenState extends State<FindPasswordAuthScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String authNumber ='';
  bool isPwValid = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      setState(() {
        isPwValid = false;
      });
      return;
    }

    if (password.length < 6 || !RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        isPwValid = false;
      });
      return;
    }

    setState(() {
      isPwValid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '비밀번호 찾기',
      appbarTitleBackgroundColor: BLUE100_COLOR,
      backgroundColor: BLUE100_COLOR,
      appbarBorderColor: BLUE200_COLOR,
      child: Stack(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.symmetric(horizontal: 24).r,
            child: Column(
              children: [
                20.verticalSpace,
                Text('가입하신 이메일을 입력해주세요.',style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),textAlign: TextAlign.center,),
                20.verticalSpace,
                ComponentButton2(
                  controller: controller,
                  hintText: '숫자 6자리 입력',
                  type:  TextInputType.number,
                  onPressed: controller.clear,
                  onChanged: validatePassword,
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Text('인증 번호를 받지 못하셨나요?', style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),),
                    6.horizontalSpace,
                    Text('다시보내기',style: AppTextStyles.caption2.copyWith(
                      color: ERROR_TEXT_COLOR,
                      decoration: TextDecoration.underline,
                      decorationColor: ERROR_TEXT_COLOR,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 0.07 * 12.sp,
                    ),)
                  ],
                )
              ],
            ),
          ),
          CustomButton(
              backgroundColor: BLUE400_COLOR,
              foregroundColor: WHITE100_COLOR,
              disabledBackgroundColor: WHITE100_COLOR,
              disabledForegroundColor: GRAY400_COLOR,
              text: '확인',
              textStyle: AppTextStyles.title,
              isEnabled: isPwValid,
              onTap: (){
                // TODO: 인증번호 전송하는 로직
                CustomSnackBar.show(
                    context: context,
                    message: '인증 번호가 불일치합니다. 다시 시도해 주세요.',
                    imagePath: 'assets/image/x.svg'
                );
              }
          ),
        ],
      ),
    );
  }
}


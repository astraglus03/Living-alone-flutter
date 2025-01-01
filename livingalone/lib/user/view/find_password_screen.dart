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
import 'package:livingalone/user/view/signup_authentication_screen.dart';
import 'package:livingalone/user/view/signup_terms_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindPasswordScreen extends StatefulWidget {
  static String get routeName => 'findPw';

  const FindPasswordScreen({super.key});

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String email ='';
  bool isButtonEnabled = false;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // 이메일 유효성 검사를 위한 정규식
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  void onEmailChanged(String value) {
    setState(() {
      email = value;
      isButtonEnabled = emailRegExp.hasMatch(email) && email.isNotEmpty;
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
                Text('이메일로 인증번호를 보내드립니다.\n이메일 확인 후 인증 번호를 입력하고 안내에 따라\n 비밀번호를 재설정해 주세요.', style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),textAlign: TextAlign.center,),
                20.verticalSpace,
                ComponentButton2(
                  controller: controller,
                  hintText: '학교 이메일',
                  type:  TextInputType.emailAddress,
                  onPressed: controller.clear,
                  onChanged: onEmailChanged,
                ),
              ],
            ),
          ),
          CustomButton(
            backgroundColor: BLUE400_COLOR,
            foregroundColor: WHITE100_COLOR,
            disabledBackgroundColor: WHITE100_COLOR,
            disabledForegroundColor: GRAY400_COLOR,
            text: '인증메일 전송',
            textStyle: AppTextStyles.title,
            isEnabled: isButtonEnabled,
            onTap: (){
              // TODO: 인증번호 전송하는 로직
            }
          ),
        ],
      ),
    );
  }
}


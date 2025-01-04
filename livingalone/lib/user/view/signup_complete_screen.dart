import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/view/root_tab.dart';
import 'package:livingalone/home/component/post_type.dart';
import 'package:livingalone/home/view/living_detail_screen.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupCompleteScreen extends StatelessWidget {
  static String get routeName => 'signupComplete';
  const SignupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            331.verticalSpace,
            SvgPicture.asset('assets/image/Check.svg'),
            20.verticalSpace,
            Text('회원가입 완료',style: AppTextStyles.title.copyWith(color: BLUE400_COLOR)),
            8.verticalSpace,
            // TODO: 닉네임으로 추후 변경
            Text('고얌미님, 환영합니다!', style: AppTextStyles.heading1.copyWith(color: GRAY800_COLOR),),
            234.verticalSpace,
            CustomBottomButton(
              backgroundColor: BLUE400_COLOR,
              foregroundColor: WHITE100_COLOR,
              appbarBorder: false,
              text: '확인',
              textStyle: AppTextStyles.title,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => RootTab()),
                      (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/view/terms_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: BLUE400_COLOR,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/splashLogo.png',
                ),
                const SizedBox(height: 20,),
                Text.rich(
                  TextSpan(
                    text: '믿을 수 있는 양도의 시작, ',
                    style: AppTextStyles.splashTitle,
                    children: <TextSpan>[
                      // TODO: 피그마상으로는 800강조인데 900해야 피그마처럼 두드러져서 서은님이랑 대화 필요.
                      TextSpan(
                        text: '모양',
                        style: AppTextStyles.splashTitle.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          CustomButton(
            backgroundColor: WHITE100_COLOR,
            foregroundColor: BLUE400_COLOR,
            text: '시작하기',
            textStyle: AppTextStyles.title,
            onTap: () {
              // TODO: 나중에 go router 적용할 것. 임시로 넣어둠.
              // context.goNamed('terms');
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => TermsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

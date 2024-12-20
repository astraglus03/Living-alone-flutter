import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: BLUE400_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/splashLogo.png',),
            SizedBox(height: 20,),
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
    );
  }
}

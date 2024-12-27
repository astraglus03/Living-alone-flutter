import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/image/Check.svg'),
                const SizedBox(height: 16),
                Text('회원가입 완료',style: AppTextStyles.heading1.copyWith(color: GRAY800_COLOR))],
            ),
            CustomButton(
              backgroundColor: BLUE400_COLOR,
              foregroundColor: WHITE100_COLOR,
              text: '확인',
              textStyle: AppTextStyles.title,
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

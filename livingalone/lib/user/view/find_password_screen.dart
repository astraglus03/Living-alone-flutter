import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view/find_password_auth_screen.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

class FindPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'find-password';

  const FindPasswordScreen({super.key});

  @override
  ConsumerState<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends ConsumerState<FindPasswordScreen> {
  final _emailController = TextEditingController();
  String email = '';
  bool _isButtonEnabled = false;

  final List<String> _schoolDomains = [
    'sangmyung.kr',
    'hoseo.ac.kr',
    'dankook.ac.kr',
    'bu.ac.kr',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void onEmailChanged(String value) {
    setState(() {
      email = value;
      _isButtonEnabled = _EmailValidator.isValid(email, _schoolDomains);
    });
  }

  Future<void> _handleEmailVerification() async {
    if (!_isButtonEnabled) return;

    try {
      final response = await ref.read(userMeProvider.notifier).sendVerificationEmail(email);

      if (response.success) {
        context.goNamed(
          FindPasswordAuthScreen.routeName,
          extra: {
            'email': email,
            'verificationCode': response.verificationCode,
          },
        );
      } else {
        CustomSnackBar.show(
          context: context,
          message: '이메일 전송에 실패했습니다.',
          imagePath: 'assets/image/x.svg',
        );
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: '이메일 전송에 실패했습니다.',
        imagePath: 'assets/image/x.svg',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '비밀번호 찾기',
      appbarTitleBackgroundColor: BLUE100_COLOR,
      backgroundColor: BLUE100_COLOR,
      appbarBorderColor: BLUE200_COLOR,
      child: Column(
        children: [
          Expanded(
            child: _FindPasswordContent(
              emailController: _emailController,
              onEmailChanged: onEmailChanged,
            ),
          ),
          _FindPasswordButton(
            isEnabled: _isButtonEnabled,
            onTap: _handleEmailVerification,
          ),
        ],
      ),
    );
  }
}

class _FindPasswordContent extends StatelessWidget {
  final TextEditingController emailController;
  final ValueChanged<String> onEmailChanged;

  const _FindPasswordContent({
    required this.emailController,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              20.verticalSpace,
              _HeaderText(),
              20.verticalSpace,
              _DescriptionText(),
              20.verticalSpace,
              ComponentButton2(
                controller: emailController,
                hintText: '학교 이메일',
                type: TextInputType.emailAddress,
                onPressed: emailController.clear,
                onChanged: onEmailChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '가입하신 이메일을 입력해주세요.',
      style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
      textAlign: TextAlign.center,
    );
  }
}

class _DescriptionText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일로 인증번호를 보내드립니다.\n이메일 확인 후 인증 번호를 입력하고 안내에 따라\n비밀번호를 재설정해 주세요.',
      style: AppTextStyles.body1.copyWith(color: GRAY600_COLOR),
      textAlign: TextAlign.center,
    );
  }
}

class _FindPasswordButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;

  const _FindPasswordButton({
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      backgroundColor: BLUE400_COLOR,
      foregroundColor: WHITE100_COLOR,
      disabledBackgroundColor: WHITE100_COLOR,
      disabledForegroundColor: GRAY400_COLOR,
      text: '인증메일 전송',
      textStyle: AppTextStyles.title,
      isEnabled: isEnabled,
      onTap: onTap,
    );
  }
}

class _EmailValidator {
  static final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool isValid(String email, List<String> allowedDomains) {
    if (!_emailRegExp.hasMatch(email)) return false;
    
    final domain = email.split('@').length == 2 ? email.split('@')[1] : '';
    return allowedDomains.contains(domain);
  }
}
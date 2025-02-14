import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedesignPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'reset-password';
  final String email;
  final String verificationCode;

  const RedesignPasswordScreen({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  ConsumerState<RedesignPasswordScreen> createState() =>
      _RedesignPasswordScreenState();
}

class _RedesignPasswordScreenState
    extends ConsumerState<RedesignPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode passwordFocus = FocusNode();
  bool isLooking = true;
  bool isPwValid = false;
  String? errorMessage;

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocus.dispose();
    _scrollController.dispose();
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

  void _showErrorSnackBar(String message) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    CustomSnackBar.show(
      context: context,
      message: message,
      imagePath: 'assets/image/x1.svg',
      bottomOffset: bottomInset > 0 ? bottomInset + 40.h : null,
    );
  }

  Future<void> _handlePasswordReset() async {
    if (!isPwValid) {
      validatePassword(passwordController.text);
      return;
    }

    try {
      await ref.read(userMeProvider.notifier).resetPassword(
            email: widget.email,
            verificationCode: widget.verificationCode,
            newPassword: passwordController.text,
          );
      context.goNamed('password-finish');
    } catch (e) {
      _showErrorSnackBar('비밀번호 재설정에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultLayout(
        backgroundColor: BLUE100_COLOR,
        appbarTitleBackgroundColor: BLUE100_COLOR,
        appbarBorderColor: BLUE200_COLOR,
        showBackButton: false,
        title: '비밀번호 찾기',
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                    child: Column(
                      children: [
                        23.verticalSpace,
                        Text(
                          '비밀번호를 재설정해 주세요',
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        20.verticalSpace,
                        CustomSignupField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          hintText: '6자 이상 입력(영문+숫자)',
                          obscureText: isLooking,
                          type: TextInputType.visiblePassword,
                          subTitle: '비밀번호',
                          submitButtonTitle: isLooking ? '비밀번호 보기' : '비밀번호 숨기기',
                          buttonBackground: WHITE100_COLOR,
                          formFieldBackground: WHITE100_COLOR,
                          onPressed: () {
                            passwordController.clear();
                            setState(() {
                              isPwValid = false;
                              errorMessage = null;
                            });
                          },
                          // FIXME: 피그마 101 113
                          width: isLooking ? 105.w : 117.w,
                          errorText: errorMessage,
                          onChanged: validatePassword,
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
            ),
            CustomButton(
              backgroundColor: isPwValid ? BLUE400_COLOR : WHITE100_COLOR,
              foregroundColor: isPwValid ? WHITE100_COLOR : GRAY400_COLOR,
              text: '완료',
              textStyle: AppTextStyles.title,
              onTap: _handlePasswordReset,
            ),
          ],
        ),
      ),
    );
  }
}

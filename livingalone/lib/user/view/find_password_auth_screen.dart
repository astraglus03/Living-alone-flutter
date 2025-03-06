import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/view_models/go_router.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view/redesign_password_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/view_models/timer_provider.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';

class FindPasswordAuthScreen extends ConsumerStatefulWidget {
  static String get routeName => 'password-auth';
  final String email;
  final String? verificationCode;

  const FindPasswordAuthScreen({
    required this.email,
    this.verificationCode,
    super.key,
  });

  @override
  ConsumerState<FindPasswordAuthScreen> createState() => _FindPasswordAuthScreenState();
}

class _FindPasswordAuthScreenState extends ConsumerState<FindPasswordAuthScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isPwValid = false;

  @override
  void initState() {
    super.initState();
    // 페이지 시작과 동시에 타이머 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timerProvider.notifier).startTimer();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void validatePassword(String password) {
    setState(() {
      isPwValid = password.length == 6 && RegExp(r'[0-9]').hasMatch(password);
    });
  }

  void _showErrorSnackBar(String message) {

    CustomSnackBar.show(
      context: context,
      message: message,
      imagePath: 'assets/image/x1.svg',
    );
  }

  Future<void> _resendVerificationCode() async {
    try {
      final response = await ref.read(userMeProvider.notifier).sendVerificationEmail(widget.email);

      if (response.success) {
        ref.read(timerProvider.notifier).startTimer();
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      _showErrorSnackBar('인증코드 재전송에 실패했습니다.');
    }
  }

  Future<void> _verifyCode() async {
    try {
      // 서버에서 받은 임시코드와 사용자 입력 비교
      if (widget.verificationCode != null && widget.verificationCode == controller.text) {
        // 코드가 일치하면 바로 다음 화면으로 이동
        context.goNamed('reset-password', extra: {
          'email': widget.email,
          'code': controller.text,
        });
      } else {
        // 코드가 일치하지 않으면 서버에 검증 요청
        final response = await ref.read(userMeProvider.notifier).sendVerifyCode(widget.email, controller.text);

        if (response.success) {
          context.goNamed('reset-password', extra: {
            'email': widget.email,
            'code': controller.text,
          });
        } else {
          _showErrorSnackBar(response.message);
        }
      }
    } catch (e) {
      _showErrorSnackBar('인증번호가 올바르지 않습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return DefaultLayout(
      title: '비밀번호 찾기',
      appbarTitleBackgroundColor: BLUE100_COLOR,
      backgroundColor: BLUE100_COLOR,
      appbarBorderColor: BLUE200_COLOR,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                controller: scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24).r,
                  child: Column(
                    children: [
                      23.verticalSpace,
                      Text(
                        '인증 번호를 입력해 주세요.',
                        style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                        textAlign: TextAlign.center,
                      ),
                      20.verticalSpace,
                      ComponentButton2(
                        controller: controller,
                        hintText: '숫자 6자리 입력',
                        type: TextInputType.number,
                        onPressed: controller.clear,
                        onChanged: validatePassword,
                        backgroundColor: GRAY100_COLOR,
                        timerText: timerNotifier.formatTime(),
                        showTimer: timerState.isActive,
                      ),
                      4.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '인증 번호를 받지 못하셨나요?',
                                style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
                              ),
                              6.horizontalSpace,
                              GestureDetector(
                                onTap: timerState.isActive ? null : _resendVerificationCode,
                                child: Text(
                                  '다시보내기',
                                  style: AppTextStyles.caption2.copyWith(
                                    color: timerState.isActive ? GRAY400_COLOR : ERROR_TEXT_COLOR,
                                    decoration: timerState.isActive ? null : TextDecoration.underline,
                                    decorationColor: ERROR_TEXT_COLOR,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 0.07 * 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
            onTap: _verifyCode,
          ),
        ],
      ),
    );
  }
}


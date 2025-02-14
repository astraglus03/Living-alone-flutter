import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view/signup_phone_verify_screen.dart';
import 'package:livingalone/user/view_models/timer_provider.dart';

class SignupAuthenticationScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signupAuthentication';
  const SignupAuthenticationScreen({super.key});

  @override
  _SignupAuthenticationScreenState createState() => _SignupAuthenticationScreenState();
}

class _SignupAuthenticationScreenState extends ConsumerState<SignupAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _emailKey = GlobalKey();
  final _verifyKey = GlobalKey();
  final schoolController = TextEditingController();
  final schoolEmailController = TextEditingController();
  final verifyNumController = TextEditingController();
  final emailFocus = FocusNode();
  final verifyFocus = FocusNode();
  List<String> searchResults = [];
  bool isDropdownOpen = false;
  bool isEmailSent = false;

  final List<String> _schools = [
    '상명대학교 천안 캠퍼스',
    '호서대학교 천안 캠퍼스',
    '단국대학교 천안 캠퍼스',
    '백석대학교 천안 캠퍼스',
  ];

  // 학교별 이메일 도메인 매핑
  final Map<String, String> _schoolDomains = {
    '상명대학교 천안 캠퍼스': 'sangmyung.kr',
    '호서대학교 천안 캠퍼스': 'hoseo.ac.kr',
    '단국대학교 천안 캠퍼스': 'dankook.ac.kr',
    '백석대학교 천안 캠퍼스': 'bu.ac.kr',
  };

  bool _validateSchool() {
    if (schoolController.text.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: '학교를 선택해 주세요.',
        imagePath: 'assets/image/x.svg',
      );
      return false;
    }
    return true;
  }

  bool _validateEmail() {
    final email = schoolEmailController.text;
    if (email.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: '학교 이메일을 입력해 주세요.',
        imagePath: 'assets/image/x.svg',
      );
      return false;
    }
    
    // 이메일 형식 검사
    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email)) {
      CustomSnackBar.show(
        context: context,
        message: '올바른 이메일 형식이 아닙니다.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }

    // 선택된 학교가 없는 경우
    if (schoolController.text.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: '먼저 학교를 선택해 주세요.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }

    // 학교 도메인 검사
    final selectedSchoolDomain = _schoolDomains[schoolController.text];
    if (selectedSchoolDomain == null) {
      CustomSnackBar.show(
        context: context,
        message: '선택된 학교의 이메일 도메인 정보가 없습니다.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }

    // 이메일 도메인이 선택된 학교와 일치하는지 검사
    if (!email.endsWith('@$selectedSchoolDomain')) {
      CustomSnackBar.show(
        context: context,
        message: '학교의 이메일 도메인과 일치하지 않습니다.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }

    return true;
  }

  bool _validateVerificationCode() {
    final code = verifyNumController.text;
    if (code.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: '인증번호를 입력해 주세요.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }

    if (code.length != 6) {
      CustomSnackBar.show(
        context: context,
        message: '인증번호는 6자리여야 합니다.',
        imagePath: 'assets/image/x1.svg',
      );
      return false;
    }
    return true;
  }

  void _showErrorSnackBar() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    CustomSnackBar.show(
      context: context,
      message: '인증 번호가 불일치합니다. 다시 시도해 주세요.',
      imagePath: 'assets/image/x1.svg',
      bottomOffset: bottomInset > 0 ? bottomInset + 40.h : null,
    );
  }

  void _sendVerificationEmail() {
    if (_validateEmail()) {
      setState(() {
        isEmailSent = true;
        FocusScope.of(context).unfocus();
      });
      verifyNumController.clear();
      ref.read(timerProvider.notifier).startTimer();
      CustomSnackBar.show(
        context: context,
        message: '인증 메일이 전송되었습니다.',
        imagePath: 'assets/image/authentication_check.svg'
      );
    }
  }

  bool get isFormValid {
    return schoolController.text.isNotEmpty &&
           schoolEmailController.text.isNotEmpty &&
           RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(schoolEmailController.text) &&
           verifyNumController.text.length == 6;
  }

  @override
  void initState() {
    super.initState();
    // 각 컨트롤러에 리스너 추가
    schoolController.addListener(_onFormChanged);
    schoolEmailController.addListener(_onFormChanged);
    verifyNumController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    // 리스너 제거
    schoolController.removeListener(_onFormChanged);
    schoolEmailController.removeListener(_onFormChanged);
    verifyNumController.removeListener(_onFormChanged);
    
    schoolController.dispose();
    schoolEmailController.dispose();
    verifyNumController.dispose();
    emailFocus.dispose();
    verifyFocus.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      // 폼 상태가 변경되었음을 알림
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      currentStep: 1,
      totalSteps: 4,
      title: '회원가입',
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text('대학생 인증을 해주세요', style: AppTextStyles.heading1,),
                        40.verticalSpace,
                        _buildSchoolField(),
                        24.verticalSpace,
                        _buildEmailField(),
                        24.verticalSpace,
                        _buildVerifyField(),
                        4.verticalSpace,
                        if(isEmailSent == true)
                          Row(
                            children: [
                              Text(
                                '인증 번호를 받지 못하셨나요?',
                                style: AppTextStyles.caption2.copyWith(color: GRAY800_COLOR),
                              ),
                              6.horizontalSpace,
                              GestureDetector(
                                onTap: isEmailSent && !ref.watch(timerProvider).isActive
                                  ? _sendVerificationEmail
                                  : null,
                                child: Text(
                                  '다시보내기',
                                  style: AppTextStyles.caption2.copyWith(
                                    color: (isEmailSent && !ref.watch(timerProvider).isActive)
                                      ? ERROR_TEXT_COLOR
                                      : GRAY400_COLOR,
                                    decoration: (isEmailSent && !ref.watch(timerProvider).isActive)
                                      ? TextDecoration.underline
                                      : null,
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
                  ),
                ),
              ),
            ),
          ),
          CustomBottomButton(
            backgroundColor: isFormValid ? BLUE400_COLOR : GRAY200_COLOR,
            foregroundColor: isFormValid ? WHITE100_COLOR : GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (!_validateSchool()) return;
              if (!_validateEmail()) return;
              if (!_validateVerificationCode()) return;

              if (_formKey.currentState!.validate()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SignupPhoneVerifyScreen(),
                  ),
                );
                ref.read(timerProvider.notifier).resetTimer();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('학교', style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR)),
        10.verticalSpace,
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
              },
              child: Container(
                width: 345.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: WHITE100_COLOR,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: GRAY200_COLOR),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          schoolController.text.isEmpty
                              ? '학교를 선택해 주세요'
                              : schoolController.text,
                          style: AppTextStyles.subtitle.copyWith(
                            color: schoolController.text.isEmpty
                                ? GRAY400_COLOR
                                : GRAY800_COLOR,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () {
                        schoolController.clear();
                        setState(() {
                          isDropdownOpen = false;
                        });
                      },
                      icon: SvgPicture.asset('assets/image/signupDelete.svg', fit: BoxFit.cover,),
                    ),
                  ],
                ),
              ),
            ),
            if (isDropdownOpen)
              Column(
                children: [
                  8.verticalSpace,
                  Container(
                    height: (_schools.length * 56.h) + ((_schools.length - 1) * 1.h),
                    decoration: BoxDecoration(
                      color: WHITE100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(10)).r,
                      border: Border.all(color: GRAY200_COLOR),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _schools.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1.h,
                        color: GRAY200_COLOR,
                      ),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 56.h,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                schoolController.text = _schools[index];
                                isDropdownOpen = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              child: Text(
                                _schools[index],
                                style: AppTextStyles.subtitle.copyWith(
                                  color: GRAY800_COLOR,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomSignupField(
      key: _emailKey,
      controller: schoolEmailController,
      focusNode: emailFocus,
      hintText: '학교 이메일을 입력해주세요',
      type: TextInputType.emailAddress,
      subTitle: '학교 이메일',
      submitButtonTitle: '인증 번호 발송',
      // TODO: 피그마 104
      width: 108.w,
      onPressed: schoolEmailController.clear,
      onTap: (){
        isEmailSent ? null : _sendVerificationEmail();
      },
      buttonBackground: isEmailSent ? GRAY100_COLOR : BLUE100_COLOR,
      buttonForeground: isEmailSent ? GRAY200_COLOR : BLUE400_COLOR,
    );
  }

  Widget _buildVerifyField() {
    final timerState = ref.watch(timerProvider);

    return CustomSignupField(
      key: _verifyKey,
      controller: verifyNumController,
      focusNode: verifyFocus,
      hintText: '인증번호를 입력해주세요',
      type: TextInputType.number,
      subTitle: '인증 번호',
      // TODO: 피그마 49
      width: 52.w,
      onPressed: verifyNumController.clear,
      onTap: () {
        if (_validateVerificationCode()) {
          _showErrorSnackBar();
        }
      },
      timer: timerState.isActive,
      timerText: timerState.isActive
          ? ref.read(timerProvider.notifier).formatTime()
          : null,
    );
  }
}

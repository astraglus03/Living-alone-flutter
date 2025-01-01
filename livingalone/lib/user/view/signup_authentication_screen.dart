import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';
import 'package:livingalone/user/view_models/timer_provider.dart';

class SignupAuthenticationScreen extends ConsumerStatefulWidget {
  static String get routeName => 'signupAuthentication';
  const SignupAuthenticationScreen({super.key});

  @override
  _SignupAuthenticationScreenState createState() => _SignupAuthenticationScreenState();
}

class _SignupAuthenticationScreenState extends ConsumerState<SignupAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSchool;
  final TextEditingController schoolEmailController = TextEditingController();
  final TextEditingController verifyNumController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode verifyFocus = FocusNode();
  final List<String> _schools = [
    '상명대학교 천안 캠퍼스',
    '호서대학교 천안 캠퍼스',
    '단국대학교 천안 캠퍼스',
    '백석대학교 천안 캠퍼스',
  ];

  final _scrollController = ScrollController();
  final _emailKey = GlobalKey();
  final _verifyKey = GlobalKey();

  void _scrollToField(GlobalKey key) {
    Future.delayed(Duration(milliseconds: 300), () {
      final RenderObject? renderObject = key.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.1,
          duration: Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  void dispose() {
    schoolEmailController.dispose();
    verifyNumController.dispose();
    emailFocus.dispose();
    verifyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      actionString: '1',
      title: '회원가입',
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // 폼 필드 외의 영역 터치시 키보드 닫음.
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height-40,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text('대학생 인증을 해주세요', style: AppTextStyles.heading1,),
                      40.verticalSpace,
                      _buildDropdownField(),
                      24.verticalSpace,
                      _buildEmailField(),
                      24.verticalSpace,
                      _buildVerifyField(),
                      4.verticalSpace,
                      if(ref.watch(timerProvider).isActive)
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
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomButton(
            backgroundColor: GRAY200_COLOR,
            foregroundColor: GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                // TODO: 유효성 검사 처리 로직
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('학교', style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR)),
        10.verticalSpace,
        SizedBox(
          width: 345.w,
          height: 56.h,
          child: DropdownButtonFormField<String>(
            hint: Align(
              alignment: Alignment.center,
              child: Text('학교를 선택해 주세요', style: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),),
            ),
            icon: const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
            // 아래 화살표 지우기
            dropdownColor: WHITE100_COLOR,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed:(){
                  setState(() {
                    selectedSchool = null;
                    schoolEmailController.clear();
                    verifyNumController.clear();
                  });
                },
                icon: SvgPicture.asset('assets/image/signupDelete.svg'),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: baseBorder),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: baseBorder,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: baseBorder,
              ),
            ),
            value: selectedSchool,
            items: _schools.map((String school) {
              return DropdownMenuItem(
                value: school,
                child: Text(
                  school,
                  style: AppTextStyles.subtitle
                      .copyWith(color: GRAY800_COLOR),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedSchool = value!;
              });
            },
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return '학교를 선택해주세요';
            //   }
            //   return null;
            // },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomSignupField(
      key: _emailKey,
      onTextFieldTap: () => _scrollToField(_verifyKey),
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
        ref.read(timerProvider.notifier).startTimer();
        CustomSnackBar.show(
            context: context,
            message: '인증 메일이 전송되었습니다.',
            imagePath: 'assets/image/authentication_check.svg'
        );
      },
    );
  }

  Widget _buildVerifyField() {
    final timerState = ref.watch(timerProvider);
    
    return CustomSignupField(
      key: _verifyKey,
      onTextFieldTap: () => _scrollToField(_verifyKey),
      controller: verifyNumController,
      focusNode: verifyFocus,
      hintText: '인증번호를 입력해주세요',
      type: TextInputType.number,
      subTitle: '인증 번호',
      submitButtonTitle: '확인',
      // TODO: 피그마 49
      width: 52.w,
      onPressed: verifyNumController.clear,
      onTap: () {
        CustomSnackBar.show(
            context: context,
            message: '인증 번호가 불일치 합니다. 다시 시도해 주세요.',
            imagePath: 'assets/image/x.svg'
        );
      },
      timer: timerState.isActive,
      timerText: timerState.isActive 
          ? ref.read(timerProvider.notifier).formatTime()
          : null,
    );
  }
}

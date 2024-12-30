import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({super.key});

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedMobileCarrier;
  final TextEditingController mobileNumController = TextEditingController();
  final TextEditingController verifyNumController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode verifyFocus = FocusNode();

  final _scrollController = ScrollController();
  final _phoneKey = GlobalKey();
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

  final List<String> _schools = [
    'SKT',
    'KT',
    'LGU+',
    '알뜰폰',
  ];

  @override
  void dispose() {
    mobileNumController.dispose();
    verifyNumController.dispose();
    phoneFocus.dispose();
    verifyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: WHITE100_COLOR,
      actionString: '2',
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
                  height: MediaQuery.of(context).size.height-50,
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text('휴대폰 번호를 입력해주세요', style: AppTextStyles.heading1,),
                      40.verticalSpace,
                      Text(
                        '통신사',
                        style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        width: 345.w,
                        height: 56.h,
                        child: DropdownButtonFormField<String>(
                          hint: Align(
                            alignment: Alignment.center,
                            child: Text('통신사를 선택해 주세요', style: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR,),),
                          ),
                          icon: const Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                          // 아래 화살표 지우기
                          dropdownColor: WHITE100_COLOR,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 16.0).r,
                            suffixIcon: IconButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed:(){
                                setState(() {
                                  selectedMobileCarrier = null;
                                  mobileNumController.clear();
                                  verifyNumController.clear();
                                });
                              },
                              icon: SvgPicture.asset('assets/image/signupDelete.svg'),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: baseBorder),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: baseBorder,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: baseBorder,
                            ),
                          ),
                          value: selectedMobileCarrier,
                          items: _schools.map((String school) {
                            return DropdownMenuItem(
                              value: school,
                              child: Text(
                                school,
                                style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedMobileCarrier = value!;
                              // _showEmailField = newValue != null;
                              // 학교가 변경되면 이메일과 인증 필드 초기화
                              // if (selectedSchool != newValue) {
                              //   _showVerificationField = false;
                              //   _isEmailSent = false;
                              // }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '통신사를 선택해주세요';
                            }
                            return null;
                          },
                        ),
                      ),
                      24.verticalSpace,
                      CustomSignupField(
                        controller: mobileNumController,
                        onTextFieldTap: () => _scrollToField(_phoneKey),
                        key: _phoneKey,
                        focusNode: phoneFocus,
                        hintText: '휴대폰 번호를 입력해 주세요',
                        type: TextInputType.phone,
                        validateText: '휴대폰 번호를',
                        subTitle: '휴대폰 번호',
                        submitButtonTitle: '인증 번호 발송',
                        // FIXME: 피그마 104 but 105 필요
                        width: 105.w,
                        onPressed: mobileNumController.clear,
                        // TODO: 인증 번호 눌렀을때의 함수
                        onTap: () {},
                      ),
                      24.verticalSpace,
                      CustomSignupField(
                        controller: verifyNumController,
                        onTextFieldTap: () => _scrollToField(_verifyKey),
                        key: _verifyKey,
                        focusNode: verifyFocus,
                        hintText: '인증번호를 입력해주세요',
                        type: TextInputType.number,
                        validateText: '인증번호를',
                        subTitle: '인증 번호',
                        submitButtonTitle: '확인',
                        width: 49.w,
                        onPressed: verifyNumController.clear,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '인증번호를 입력해주세요';
                          }
                          // TODO: 인증번호와 입력번호가 일치하는지 유효성 검사 로직 추후 필요
                          return null;
                        },
                        // TODO: 확인 버튼 눌렀을때의 함수 -> 인증번호가 다를경우 스낵바 띄우기 정상이라면 정상루트로 진행
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: GRAY400_COLOR,
                                duration: const Duration(seconds: 2),
                              padding: EdgeInsets.symmetric(horizontal: 12.0.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0.r),
                              ),
                              // width: 345,
                              behavior: SnackBarBehavior.floating,
                              //FIXME: 실제로 크기를 맞추려고하는데 해당 위젯의 크기가 조금씩 달라서 크기를 조절했음.
                              margin: EdgeInsets.only(left: 24.w, right: 24.h, bottom: 60.h),
                              elevation: 0,
                              // animation: _animation,
                              content: SizedBox(
                                height: 48.h,
                                child: Row(
                                  children: [
                                    Image.asset('assets/image/x.png'),
                                    10.horizontalSpace,
                                    Text('인증 번호가 불일치 합니다. 다시 시도해 주세요', style: AppTextStyles.body1.copyWith(color: WHITE100_COLOR),)
                                  ],
                                ),
                              )
                            ),
                          );
                        },
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
}

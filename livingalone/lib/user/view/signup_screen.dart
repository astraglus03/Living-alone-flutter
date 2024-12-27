import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/component/custom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:email_validator/email_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSchool;
  final TextEditingController schoolEmailController = TextEditingController();
  final TextEditingController verifyNumController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode verifyFocus = FocusNode();

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

  final List<String> _schools = [
    '상명대학교 천안 캠퍼스',
    '호서대학교 천안 캠퍼스',
    '단국대학교 천안 캠퍼스',
    '백석대학교 천안 캠퍼스',
  ];

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
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text('대학생 인증을 해주세요', style: AppTextStyles.heading1,),
                      const SizedBox(height: 40,),
                      Text(
                        '학교',
                        style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 345,
                        // height: 56,
                        child: DropdownButtonFormField<String>(
                          hint: Align(
                            alignment: Alignment.center,
                            child: Text('헉교를 선택해 주세요', style: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),),
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
                              icon: Image.asset('assets/image/suffix_delete.png'),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: baseBorder),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: baseBorder,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                              return '학교를 선택해주세요';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomSignupField(
                        controller: schoolEmailController,
                        onTextFieldTap: () => _scrollToField(_emailKey),
                        key: _emailKey,
                        focusNode: emailFocus,
                        hintText: '학교 이메일을 입력해주세요',
                        type: TextInputType.emailAddress,
                        validateText: '이메일을',
                        subTitle: '학교 이메일',
                        submitButtonTitle: '인증 번호 발송',
                        onPressed: schoolEmailController.clear,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }

                          if (EmailValidator.validate(value)) {
                            return '유효한 이메일 주소를 입력해주세요';
                          }
                          return null;
                        },
                        // TODO: 인증 번호 눌렀을때의 함수
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),
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
                        width: 49,
                        onPressed: verifyNumController.clear,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '인증번호를 입력해주세요';
                          }
                          // TODO: 인증번호와 입력번호가 일치하는지 유효성 검사 로직 추후 필요
                          return null;
                        },
                        // TODO: 확인 버튼 눌렀을때의 함수
                        onTap: () {},
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

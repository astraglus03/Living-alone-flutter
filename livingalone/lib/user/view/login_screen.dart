import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingalone/common/component/common_button.dart';
import 'package:livingalone/user/component/custom_input_field.dart';
import 'package:livingalone/user/component/find_signup_button.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/user/view/find_password_screen.dart';
import 'package:livingalone/user/view/signup_terms_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//FIXME: 생체인증에 관련된 코드는 아래에 모두 주석처리해 놓았음. 현재는 아이디 비밀번호 입력으로 진행. or flutter secure storage에 토큰 + 키체인 내용 둘다 저장하고 불러오기.

class LoginScreen extends StatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // String userId='';
  // String userPw='';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: BLUE100_COLOR,
      appbarTitleBackgroundColor: BLUE100_COLOR,
      appbarBorderColor: BLUE200_COLOR,
      title: '로그인',
      showBackButton: false,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.fromLTRB(24.w, 42.h, 24.w, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                controller: idController,
                autofillHint: [AutofillHints.email],
                hintText: '학교 이메일을 입력해 주세요',
              ),
              16.verticalSpace,
              CustomInputField(
                controller: passwordController,
                autofillHint: [AutofillHints.password],
                hintText: '비밀번호를 입력해 주세요',
                obscureText: true,
              ),
              16.verticalSpace,
              CommonButton(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BLUE400_COLOR,
                      foregroundColor: WHITE100_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      )),
                  onPressed: () {
                    // TODO: go router 나중에 적용하기.
                  },
                  child: Text('로그인', style: AppTextStyles.title),
                ),
              ),
              16.verticalSpace,
              SizedBox(
                width: 345.w,
                height: 36.h,
                child: Row(
                  children: [
                    FindSignupButton(
                        onTap: () {
                          // TODO: 비밀번호 찾기 페이지 라우팅 임시처리
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> FindPasswordScreen()));
                        },
                        text: '비밀번호 찾기'
                    ),
                    9.horizontalSpace,
                    FindSignupButton(
                        onTap: () {
                          // TODO: 회원가입 페이지 라우팅 임시처리
                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SignupTermsScreen()));
                        },
                        text: '회원가입'
                    ),
                  ],
                ),
              ),
              384.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("• ", style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR)),
                  ),
                  Expanded(
                    child: Text(
                      "로그인 및 회원가입 완료 이후 ‘자동 로그인'됩니다. 본인 기기가 아닌 경우 [마이]에서 ‘로그아웃’을 해주세요.",
                      style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final LocalAuthentication auth = LocalAuthentication();
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool CheckBiometrics = false;
//
//   @override
//   void initState() {
//     super.initState();
//     checkBiometrics();
//   }
//
//   @override
//   void dispose() {
//     idController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> checkBiometrics() async {
//     try {
//       final canCheckBiometrics = await auth.canCheckBiometrics;
//       setState(() {
//         CheckBiometrics = canCheckBiometrics;
//       });
//     } catch (e) {
//       _showError('생체 인증 확인 중 오류가 발생했습니다. 디바이스 설정을 확인해주세요.');
//     }
//   }
//
//   Future<void> authenticateAndLogin() async {
//     try {
//       final isAuthenticated = await auth.authenticate(
//         localizedReason: '생체 인증을 통해 로그인해주세요',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//           stickyAuth: true,
//         ),
//       );
//
//       if (isAuthenticated) {
//         final credentialsString = await FlutterKeychain.get(key: 'SECURE_CREDENTIALS');
//         if (credentialsString != null) {
//           final credentials = Map<String, String>.from(
//             Map<String, dynamic>.from(
//               jsonDecode(credentialsString),
//             ),
//           );
//           idController.text = credentials['email']!;
//           passwordController.text = credentials['password']!;
//           login();
//         } else {
//           _showError('저장된 자격증명을 찾을 수 없습니다. 이메일과 비밀번호를 입력해주세요.');
//         }
//       } else {
//         _showError('생체 인증이 실패했습니다. 비밀번호를 입력하거나 생체 인증 설정을 확인하세요.');
//       }
//     } catch (e) {
//       _showError('생체 인증 오류 발생: ${e.toString()}');
//     }
//   }
//
//   Future<void> login() async {
//     try {
//       final email = idController.text.trim();
//       final password = passwordController.text.trim();
//
//       if (email.isEmpty || password.isEmpty) {
//         _showError('이메일과 비밀번호를 모두 입력해주세요.');
//         return;
//       }
//
//       // TODO: 백엔드 API 통신을 구현해야하는 부분 ( 현재 코드 무의미 나중에 리팩토링 필요)
//       // 로그인 성공 가정
//       final isSuccess = true;
//       if (isSuccess) {
//         await FlutterKeychain.put(
//           key: 'SECURE_CREDENTIALS',
//           value: jsonEncode({'email': email, 'password': password}),
//         );
//       }
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignupScreen()));
//     } catch (e) {
//       _showError('로그인 처리 중 오류가 발생했습니다: ${e.toString()}');
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultLayout(
//       backgroundColor: BLUE100_COLOR,
//       appbarTitleBackgroundColor: BLUE100_COLOR,
//       title: '로그인',
//       isFirstScreen: true,
//       child: SingleChildScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           margin: const EdgeInsets.fromLTRB(24, 48, 0, 0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AutofillGroup(
//                 child: Column(
//                   children: [
//                     CustomInputField(
//                       controller: idController,
//                       // textInputAction: TextInputAction.next,
//                       autofillHint: const [AutofillHints.email],
//                       hintText: '학교 이메일을 입력해 주세요',
//                     ),
//                     const SizedBox(height: 16),
//                     CustomInputField(
//                       controller: passwordController,
//                       autofillHint: const [AutofillHints.password],
//                       hintText: '비밀번호를 입력해 주세요',
//                       obscureText: true,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               CommonButton(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: BLUE400_COLOR,
//                     foregroundColor: WHITE100_COLOR,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   onPressed: (){
//                     TextInput.finishAutofillContext(shouldSave: true);
//                     SystemChannels.textInput.invokeMethod('TextInput.hide');
//                     login();
//                   },
//                   child: Text('로그인', style: AppTextStyles.title),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               Container(
//                 width: 345,
//                 height: 36,
//                 child: Row(
//                   children: [
//                     FindSignupButton(
//                       onTap: () {
//                         // 비밀번호 찾기 기능 구현
//                       },
//                       text: '비밀번호 찾기',
//                     ),
//                     const SizedBox(width: 9),
//                     FindSignupButton(
//                       onTap: () {
//                         // 회원가입 기능 구현
//                       },
//                       text: '회원가입',
//                     ),
//                   ],
//                 ),
//               ),
//               if (CheckBiometrics)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: CommonButton(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: BLUE300_COLOR,
//                         foregroundColor: WHITE100_COLOR,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       onPressed: authenticateAndLogin,
//                       child: Text('생체 인증으로 로그인', style: AppTextStyles.title),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

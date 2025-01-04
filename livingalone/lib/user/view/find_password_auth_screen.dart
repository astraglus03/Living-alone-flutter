// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:livingalone/common/const/colors.dart';
// import 'package:livingalone/common/const/text_styles.dart';
// import 'package:livingalone/common/layout/default_layout.dart';
// import 'package:livingalone/user/component/component_button2.dart';
// import 'package:livingalone/user/component/custom_button.dart';
// import 'package:livingalone/user/component/custom_snackbar.dart';
// import 'package:livingalone/user/view/redesign_password_screen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:livingalone/user/view_models/timer_provider.dart';
//
// class FindPasswordAuthScreen extends ConsumerStatefulWidget {
//   static String get routeName => 'findPwAuth';
//
//   const FindPasswordAuthScreen({super.key});
//
//   @override
//   ConsumerState<FindPasswordAuthScreen> createState() => _FindPasswordAuthScreenState();
// }
//
// class _FindPasswordAuthScreenState extends ConsumerState<FindPasswordAuthScreen> {
//   final TextEditingController controller = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//   final FocusNode focusNode = FocusNode();
//   String authNumber = '';
//   bool isPwValid = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // 페이지 시작과 동시에 타이머 시작
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(timerProvider.notifier).startTimer();
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
//
//   void validatePassword(String password) {
//     setState(() {
//       isPwValid = password.length == 6 && RegExp(r'[0-9]').hasMatch(password);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final timerState = ref.watch(timerProvider);
//     final timerNotifier = ref.read(timerProvider.notifier);
//
//     return DefaultLayout(
//       title: '비밀번호 찾기',
//       appbarTitleBackgroundColor: BLUE100_COLOR,
//       backgroundColor: BLUE100_COLOR,
//       appbarBorderColor: BLUE200_COLOR,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: SingleChildScrollView(
//               controller: scrollController,
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 margin: EdgeInsets.symmetric(horizontal: 24).r,
//                 child: Column(
//                   children: [
//                     20.verticalSpace,
//                     Text(
//                       '가입하신 이메일을 입력해주세요.',
//                       style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
//                       textAlign: TextAlign.center,
//                     ),
//                     20.verticalSpace,
//                     ComponentButton2(
//                       controller: controller,
//                       hintText: '숫자 6자리 입력',
//                       type: TextInputType.number,
//                       onPressed: controller.clear,
//                       onChanged: validatePassword,
//                       backgroundColor: GRAY100_COLOR,
//                       timerText: timerNotifier.formatTime(),
//                       showTimer: timerState.isActive,
//                     ),
//                     4.verticalSpace,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               '인증 번호를 받지 못하셨나요?',
//                               style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
//                             ),
//                             6.horizontalSpace,
//                             GestureDetector(
//                               onTap: timerState.isActive ? null : timerNotifier.startTimer,
//                               child: Text(
//                                 '다시보내기',
//                                 style: AppTextStyles.caption2.copyWith(
//                                   color: timerState.isActive ? GRAY400_COLOR : ERROR_TEXT_COLOR,
//                                   decoration: timerState.isActive ? null : TextDecoration.underline,
//                                   decorationColor: ERROR_TEXT_COLOR,
//                                   decorationStyle: TextDecorationStyle.solid,
//                                   decorationThickness: 0.07 * 12.sp,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           CustomButton(
//             backgroundColor: BLUE400_COLOR,
//             foregroundColor: WHITE100_COLOR,
//             disabledBackgroundColor: WHITE100_COLOR,
//             disabledForegroundColor: GRAY400_COLOR,
//             text: '확인',
//             textStyle: AppTextStyles.title,
//             isEnabled: isPwValid,
//             // onTap: _showErrorSnackBar,
//             onTap: (){
//               ref.read(timerProvider.notifier).resetTimer();
//               Navigator.of(context).push(MaterialPageRoute(builder: (_) => RedesignPasswordScreen()));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//

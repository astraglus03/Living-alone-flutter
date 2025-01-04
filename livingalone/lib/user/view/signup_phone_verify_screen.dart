// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:livingalone/common/const/colors.dart';
// import 'package:livingalone/common/const/text_styles.dart';
// import 'package:livingalone/common/layout/default_layout.dart';
// import 'package:livingalone/user/component/custom_button.dart';
// import 'package:livingalone/user/component/custom_signup_field.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:livingalone/user/component/custom_snackbar.dart';
// import 'package:livingalone/user/view/signup_setting_password_screen.dart';
// import 'package:livingalone/user/view_models/timer_provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class SignupPhoneVerifyScreen extends ConsumerStatefulWidget {
//   static String get routeName => 'signupPhoneVerify';
//   const SignupPhoneVerifyScreen({super.key});
//
//   @override
//   ConsumerState<SignupPhoneVerifyScreen> createState() => _SignupPhoneVerifyScreenState();
// }
//
// class _SignupPhoneVerifyScreenState extends ConsumerState<SignupPhoneVerifyScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _scrollController = ScrollController();
//   final _phoneKey = GlobalKey();
//   final _verifyKey = GlobalKey();
//   final phoneController = TextEditingController();
//   final verifyNumController = TextEditingController();
//   final phoneFocus = FocusNode();
//   final verifyFocus = FocusNode();
//   bool isPhoneSent = false;
//   final carrierController = TextEditingController();
//   bool isCarrierDropdownOpen = false;
//
//   final List<String> _carriers = [
//     'SKT',
//     'KT',
//     'LG U+',
//     'SKT 알뜰폰',
//     'KT 알뜰폰',
//     'LG U+ 알뜰폰',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     carrierController.addListener(_onFormChanged);
//     phoneController.addListener(_onFormChanged);
//     verifyNumController.addListener(_onFormChanged);
//   }
//
//   @override
//   void dispose() {
//     carrierController.removeListener(_onFormChanged);
//     phoneController.removeListener(_onFormChanged);
//     verifyNumController.removeListener(_onFormChanged);
//
//     carrierController.dispose();
//     phoneController.dispose();
//     verifyNumController.dispose();
//     phoneFocus.dispose();
//     verifyFocus.dispose();
//     super.dispose();
//   }
//
//   void _onFormChanged() {
//     setState(() {});
//   }
//
//   void _scrollToField(GlobalKey key) {
//     Future.delayed(Duration(milliseconds: 300), () {
//       final RenderObject? renderObject = key.currentContext?.findRenderObject();
//       if (renderObject != null) {
//         Scrollable.ensureVisible(
//           key.currentContext!,
//           alignment: 0.1,
//           duration: Duration(milliseconds: 300),
//         );
//       }
//     });
//   }
//
//   bool _validatePhone() {
//     final phone = phoneController.text;
//     if (phone.isEmpty) {
//       CustomSnackBar.show(
//         context: context,
//         message: '휴대폰 번호를 입력해 주세요.',
//         imagePath: 'assets/image/x1.svg',
//       );
//       return false;
//     }
//
//     if (!RegExp(r'^010[0-9]{8}$').hasMatch(phone)) {
//       CustomSnackBar.show(
//         context: context,
//         message: '올바른 휴대폰 번호 형식이 아닙니다.',
//         imagePath: 'assets/image/x1.svg',
//       );
//       return false;
//     }
//     return true;
//   }
//
//   bool _validateVerificationCode() {
//     final code = verifyNumController.text;
//     if (code.isEmpty) {
//       CustomSnackBar.show(
//         context: context,
//         message: '인증번호를 입력해 주세요.',
//         imagePath: 'assets/image/x1.svg',
//       );
//       return false;
//     }
//
//     if (code.length != 6) {
//       CustomSnackBar.show(
//         context: context,
//         message: '인증번호는 6자리여야 합니다.',
//         imagePath: 'assets/image/x1.svg',
//       );
//       return false;
//     }
//     return true;
//   }
//
//   void _showErrorSnackBar() {
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;
//     CustomSnackBar.show(
//       context: context,
//       message: '인증 번호가 불일치합니다. 다시 시도해 주세요.',
//       imagePath: 'assets/image/x1.svg',
//       bottomOffset: bottomInset > 0 ? bottomInset + 40.h : null,
//     );
//   }
//
//   void _sendVerificationPhone() {
//     if (_validatePhone()) {
//       setState(() {
//         isPhoneSent = true;
//       });
//       verifyNumController.clear();
//       ref.read(timerProvider.notifier).startTimer();
//       CustomSnackBar.show(
//         context: context,
//         message: '인증 번호가 전송되었습니다.',
//         imagePath: 'assets/image/authentication_check.svg'
//       );
//     }
//   }
//
//   bool _validateCarrier() {
//     if (carrierController.text.isEmpty) {
//       CustomSnackBar.show(
//         context: context,
//         message: '통신사를 선택해 주세요.',
//         imagePath: 'assets/image/x1.svg',
//       );
//       return false;
//     }
//     return true;
//   }
//
//   bool get isFormValid {
//     return carrierController.text.isNotEmpty &&
//            phoneController.text.isNotEmpty &&
//            RegExp(r'^010[0-9]{8}$').hasMatch(phoneController.text) &&
//            verifyNumController.text.length == 6;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultLayout(
//       backgroundColor: WHITE100_COLOR,
//       currentStep: 2,
//       totalSteps: 4,
//       title: '회원가입',
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: SingleChildScrollView(
//               controller: _scrollController,
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height + 200.h,
//                   padding: EdgeInsets.symmetric(horizontal: 24.w),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       20.verticalSpace,
//                       Text('휴대폰 인증을 해주세요', style: AppTextStyles.heading1,),
//                       40.verticalSpace,
//                       _buildCarrierField(),
//                       24.verticalSpace,
//                       _buildPhoneField(),
//                       24.verticalSpace,
//                       _buildVerifyField(),
//                       4.verticalSpace,
//                       Row(
//                         children: [
//                           Text(
//                             '인증 번호를 받지 못하셨나요?',
//                             style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
//                           ),
//                           6.horizontalSpace,
//                           GestureDetector(
//                             onTap: isPhoneSent && !ref.watch(timerProvider).isActive
//                               ? _sendVerificationPhone
//                               : null,
//                             child: Text(
//                               '다시보내기',
//                               style: AppTextStyles.caption2.copyWith(
//                                 color: (isPhoneSent && !ref.watch(timerProvider).isActive)
//                                   ? ERROR_TEXT_COLOR
//                                   : GRAY400_COLOR,
//                                 decoration: (isPhoneSent && !ref.watch(timerProvider).isActive)
//                                   ? TextDecoration.underline
//                                   : null,
//                                 decorationColor: ERROR_TEXT_COLOR,
//                                 decorationStyle: TextDecorationStyle.solid,
//                                 decorationThickness: 0.07 * 12.sp,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           CustomButton(
//             backgroundColor: isFormValid ? BLUE400_COLOR : GRAY200_COLOR,
//             foregroundColor: isFormValid ? WHITE100_COLOR : GRAY800_COLOR,
//             text: '다음',
//             textStyle: AppTextStyles.title,
//             onTap: () {
//               if (!_validateCarrier()) return;
//               if (!_validatePhone()) return;
//               if (!_validateVerificationCode()) return;
//
//               if (_formKey.currentState!.validate()) {
//                 // TODO: 다음 단계로 이동
//                 ref.read(timerProvider.notifier).resetTimer();
//                 Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SignupSettingPasswordScreen()));
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPhoneField() {
//     return CustomSignupField(
//       key: _phoneKey,
//       onTextFieldTap: () => _scrollToField(_phoneKey),
//       controller: phoneController,
//       focusNode: phoneFocus,
//       hintText: '휴대폰 번호를 입력해주세요',
//       type: TextInputType.number,
//       subTitle: '휴대폰 번호',
//       submitButtonTitle: '인증 번호 발송',
//       width: 108.w,
//       onPressed: phoneController.clear,
//       onTap: () {
//         isPhoneSent ? null : _sendVerificationPhone();
//       },
//       buttonBackground: isPhoneSent ? GRAY200_COLOR : BLUE100_COLOR,
//     );
//   }
//
//   Widget _buildVerifyField() {
//     final timerState = ref.watch(timerProvider);
//
//     return CustomSignupField(
//       key: _verifyKey,
//       onTextFieldTap: () => _scrollToField(_verifyKey),
//       controller: verifyNumController,
//       focusNode: verifyFocus,
//       hintText: '인증번호를 입력해주세요',
//       type: TextInputType.number,
//       subTitle: '인증 번호',
//       submitButtonTitle: '확인',
//       width: 52.w,
//       onPressed: verifyNumController.clear,
//       onTap: () {
//         if (_validateVerificationCode()) {
//           _showErrorSnackBar();
//         }
//       },
//       timer: timerState.isActive,
//       timerText: timerState.isActive
//           ? ref.read(timerProvider.notifier).formatTime()
//           : null,
//     );
//   }
//
//   Widget _buildCarrierField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('통신사', style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR)),
//         10.verticalSpace,
//         Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isCarrierDropdownOpen = !isCarrierDropdownOpen;
//                 });
//               },
//               child: Container(
//                 width: 345.w,
//                 height: 56.h,
//                 decoration: BoxDecoration(
//                   color: WHITE100_COLOR,
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(color: GRAY200_COLOR),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.w),
//                         child: Text(
//                           carrierController.text.isEmpty
//                               ? '통신사를 선택해 주세요'
//                               : carrierController.text,
//                           style: AppTextStyles.subtitle.copyWith(
//                             color: carrierController.text.isEmpty
//                                 ? GRAY400_COLOR
//                                 : GRAY800_COLOR,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       style: IconButton.styleFrom(
//                         overlayColor: Colors.transparent,
//                       ),
//                       onPressed: () {
//                         carrierController.clear();
//                         setState(() {
//                           isCarrierDropdownOpen = false;
//                         });
//                       },
//                       icon: SvgPicture.asset('assets/image/signupDelete.svg', fit: BoxFit.cover,),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (isCarrierDropdownOpen)
//               Column(
//                 children: [
//                   8.verticalSpace,
//                   Container(
//                     height: (_carriers.length * 56.h) + ((_carriers.length - 1) * 1.h),
//                     decoration: BoxDecoration(
//                       color: WHITE100_COLOR,
//                       borderRadius: BorderRadius.all(Radius.circular(10)).r,
//                       border: Border.all(color: GRAY200_COLOR),
//                     ),
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: _carriers.length,
//                       separatorBuilder: (_, __) => Divider(
//                         height: 1.h,
//                         color: GRAY200_COLOR,
//                       ),
//                       itemBuilder: (context, index) {
//                         return SizedBox(
//                           height: 56.h,
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 carrierController.text = _carriers[index];
//                                 isCarrierDropdownOpen = false;
//                               });
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 16.w,
//                                 vertical: 16.h,
//                               ),
//                               child: Text(
//                                 _carriers[index],
//                                 style: AppTextStyles.subtitle.copyWith(
//                                   color: GRAY800_COLOR,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:livingalone/common/const/colors.dart';
// import 'package:livingalone/common/const/text_styles.dart';
// import 'package:livingalone/common/layout/default_layout.dart';
// import 'package:livingalone/user/component/custom_button.dart';
// import 'package:livingalone/user/component/custom_signup_field.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class SignupNicknameScreen extends StatefulWidget {
//   static String get routeName => 'signupNickname';
//
//   const SignupNicknameScreen({super.key});
//
//   @override
//   State<SignupNicknameScreen> createState() => _SignupNicknameScreenState();
// }
//
// class _SignupNicknameScreenState extends State<SignupNicknameScreen> {
//   final TextEditingController controller = TextEditingController();
//   final FocusNode focusNode = FocusNode();
//   bool isNicknameValid = false;
//   bool isDuplicateChecked = false;
//   String? errorMessage;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       print('이미지 선택 오류: $e');
//     }
//   }
//
//   Widget _buildProfileImage() {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: _pickImage,
//           child: Center(
//             child: Container(
//               width: 100.w,
//               height: 100.w,
//               clipBehavior: Clip.antiAlias,
//               decoration: BoxDecoration(
//                 color: BLUE200_COLOR,
//                 shape: BoxShape.circle,
//               ),
//               child: _selectedImage != null
//                   ? Image.file(
//                 _selectedImage!,
//                 fit: BoxFit.cover,
//                 width: 100.w,
//                 height: 100.w,
//               )
//                   : Padding(
//                 padding: EdgeInsets.only(top: 25),
//                 child: SvgPicture.asset(
//                   'assets/image/profile.svg',
//                   fit: BoxFit.contain,
//                   width: 80.w,
//                   height: 80.w,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           right: 125,
//           bottom: 0,
//           child: GestureDetector(
//             onTap: _pickImage,
//             child: Container(
//               width: 32.w,
//               height: 32.w,
//               decoration: BoxDecoration(
//                 color: BLUE400_COLOR,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: WHITE100_COLOR,
//                   width: 2.w,
//                 ),
//               ),
//               child: Icon(
//                 Icons.add,
//                 color: WHITE100_COLOR,
//                 size: 20.w,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void validateNickname(String value) {
//     if (value.isEmpty) {
//       setState(() {
//         errorMessage = '닉네임을 입력해주세요';
//         isNicknameValid = false;
//         isDuplicateChecked = false;
//       });
//       return;
//     }
//
//     // 한글, 영어, 숫자만 허용하는 정규식
//     final RegExp nicknameRegExp = RegExp(r'^[가-힣a-zA-Z0-9]+$');
//
//     if (!nicknameRegExp.hasMatch(value)) {
//       setState(() {
//         errorMessage = '한글, 영어, 숫자를 이용하여 10자 이하 입력해 주세요';
//         isNicknameValid = false;
//         isDuplicateChecked = false;
//       });
//       return;
//     }
//
//     if (value.length < 2 || value.length > 10) {
//       setState(() {
//         errorMessage = '한글, 영어, 숫자를 이용하여 10자 이하 입력해 주세요';
//         isNicknameValid = false;
//         isDuplicateChecked = false;
//       });
//       return;
//     }
//
//     setState(() {
//       errorMessage = null;
//     });
//   }
//
//   void checkDuplicate() {
//     if (controller.text.isEmpty) {
//       setState(() {
//         errorMessage = '닉네임을 입력해주세요';
//       });
//       return;
//     }
//
//     final value = controller.text;
//     final RegExp nicknameRegExp = RegExp(r'^[가-힣a-zA-Z0-9]+$');
//
//     if (!nicknameRegExp.hasMatch(value) || value.length < 2 || value.length > 10) {
//       validateNickname(value);
//       return;
//     }
//
//     final nickname = 'duplicate';
//     if(value == nickname){
//       setState(() {
//         errorMessage = '이미 사용중인 닉네임 입니다';
//         isNicknameValid = false;
//         isDuplicateChecked = false;
//       });
//       return;
//     }
//
//     setState(() {
//       isDuplicateChecked = true;
//       isNicknameValid = true;
//       errorMessage = null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultLayout(
//       title: '회원가입',
//       currentStep: 4,
//       totalSteps: 4,
//       child: Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 padding: EdgeInsets.symmetric(horizontal: 24.0.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     20.verticalSpace,
//                     Text(
//                       '모양에서 사용할\n프로필을 만들어 주세요',
//                       style:
//                           AppTextStyles.heading1.copyWith(color: GRAY800_COLOR),
//                     ),
//                     32.verticalSpace,
//                     _buildProfileImage(),
//                     32.verticalSpace,
//                     CustomSignupField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       hintText: '2~8자 입력(한글, 영어, 숫자 가능)',
//                       type: TextInputType.text,
//                       subTitle: '닉네임',
//                       width: 74.w,
//                       onPressed: () {
//                         controller.clear();
//                         setState(() {
//                           errorMessage = null;
//                           isDuplicateChecked = false;
//                           isNicknameValid = false;
//                         });
//                       },
//                       errorText: errorMessage,
//                       onChanged: validateNickname,
//                       submitButtonTitle: '중복확인',
//                       onTap: checkDuplicate,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           CustomButton(
//             backgroundColor: isNicknameValid ? BLUE400_COLOR : GRAY200_COLOR,
//             foregroundColor: isNicknameValid ? WHITE100_COLOR : GRAY800_COLOR,
//             text: '가입하기',
//             textStyle: AppTextStyles.title,
//             onTap: () {
//               if (isNicknameValid) {
//                 // TODO: 다음 화면으로 이동
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/repository/mypage_repository.dart';
import 'package:livingalone/mypage/view_models/mypage_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/component/custom_signup_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:livingalone/mypage/view_models/notification_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static String get routeName => 'editProfile';

  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isNicknameValid = true;  // 초기값은 true (기존 닉네임은 유효)
  bool isDuplicateChecked = true;  // 초기값은 true (기존 닉네임은 중복 확인 필요 없음)
  String? errorMessage;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 현재 사용자 프로필 정보로 초기화
    final profile = ref.read(myPageProvider);
    controller.text = profile.profile!.nickname;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  Widget _buildProfileImage() {
    final profile = ref.watch(myPageProvider);
    
    return Stack(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Center(
            child: Container(
              width: 100.w,
              height: 100.w,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: BLUE200_COLOR,
                shape: BoxShape.circle,
              ),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 100.w,
                    )
                  : profile.profile!.profileImage != null
                      ? Image.network(
                          profile.profile!.profileImage!,
                          fit: BoxFit.cover,
                          width: 100.w,
                          height: 100.w,
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: SvgPicture.asset(
                            'assets/image/profile.svg',
                            fit: BoxFit.contain,
                            width: 80.w,
                            height: 80.w,
                          ),
                        ),
            ),
          ),
        ),
        Positioned(
          right: 125,
          bottom: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: BLUE400_COLOR,
                shape: BoxShape.circle,
                border: Border.all(
                  color: WHITE100_COLOR,
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.add,
                color: WHITE100_COLOR,
                size: 20.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void validateNickname(String value) {
    if (value.isEmpty) {
      setState(() {
        errorMessage = '닉네임을 입력해주세요';
        isNicknameValid = false;
        isDuplicateChecked = false;
      });
      return;
    }

    final RegExp nicknameRegExp = RegExp(r'^[가-힣a-zA-Z0-9]+$');

    if (!nicknameRegExp.hasMatch(value)) {
      setState(() {
        errorMessage = '한글, 영어, 숫자를 이용하여 10자 이하 입력해 주세요';
        isNicknameValid = false;
        isDuplicateChecked = false;
      });
      return;
    }

    if (value.length < 2 || value.length > 10) {
      setState(() {
        errorMessage = '한글, 영어, 숫자를 이용하여 10자 이하 입력해 주세요';
        isNicknameValid = false;
        isDuplicateChecked = false;
      });
      return;
    }

    // 현재 닉네임과 같다면 중복 체크 불필요
    if (value == ref.read(notificationSettingsProvider).nickname) {
      setState(() {
        errorMessage = null;
        isNicknameValid = true;
        isDuplicateChecked = true;
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isDuplicateChecked = false;
    });
  }

  void checkDuplicate() async {
    if (controller.text.isEmpty) {
      setState(() {
        errorMessage = '닉네임을 입력해주세요';
      });
      return;
    }

    final value = controller.text;
    final RegExp nicknameRegExp = RegExp(r'^[가-힣a-zA-Z0-9]+$');

    if (!nicknameRegExp.hasMatch(value) || value.length < 2 || value.length > 10) {
      validateNickname(value);
      return;
    }

    // 현재 닉네임과 같다면 중복 체크 불필요
    if (value == ref.read(notificationSettingsProvider).nickname) {
      setState(() {
        errorMessage = null;
        isNicknameValid = true;
        isDuplicateChecked = true;
      });
      return;
    }

    try {
      // 더미 데이터 사용 시
      final result = await ref.read(dummyMyPageRepositoryProvider).checkNickname(
        nickname: value,
      );
      
      setState(() {
        errorMessage = result.message;
        isDuplicateChecked = result.available;
        isNicknameValid = result.available;
        if (result.available) {
          FocusScope.of(context).unfocus();
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = '중복 확인 중 오류가 발생했습니다';
        isNicknameValid = false;
        isDuplicateChecked = false;
      });
      print('닉네임 중복 확인 오류: $e');
    }
  }

  bool _validateAll() {
    final value = controller.text;
    
    if (value.isEmpty) {
      setState(() {
        errorMessage = '닉네임을 입력해주세요';
      });
      return false;
    }

    final RegExp nicknameRegExp = RegExp(r'^[가-힣a-zA-Z0-9]+$');
    if (!nicknameRegExp.hasMatch(value) || value.length < 2 || value.length > 10) {
      validateNickname(value);
      return false;
    }

    if (!isDuplicateChecked) {
      setState(() {
        errorMessage = '닉네임 중복 여부를 확인해 주세요';
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '프로필 수정',
      actions: _buildSubmitButton(ref),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                height: MediaQuery.of(context).size.height-250,
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    _buildProfileImage(),
                    32.verticalSpace,
                    CustomSignupField(
                      controller: controller,
                      focusNode: focusNode,
                      hintText: '2~8자 입력(한글, 영어, 숫자 가능)',
                      type: TextInputType.text,
                      subTitle: '닉네임',
                      width: 74.w,
                      onPressed: () {
                        controller.clear();
                        setState(() {
                          errorMessage = null;
                          isDuplicateChecked = false;
                          isNicknameValid = false;
                        });
                      },
                      errorText: errorMessage,
                      errorImage: !isDuplicateChecked && !isNicknameValid,
                      errorColor: isDuplicateChecked && isNicknameValid ? BLUE400_COLOR : ERROR_TEXT_COLOR,
                      onChanged: validateNickname,
                      submitButtonTitle: '중복확인',
                      onTap: checkDuplicate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(WidgetRef ref) {
    return TextButton(
      style: TextButton.styleFrom(overlayColor: Colors.transparent),
      onPressed: (){
        ref.read(myPageProvider.notifier).updateProfile(
          profileImage: _selectedImage.toString(),
          nickname: controller.text.trim(),
        );
        Navigator.of(context).pop();
      },
      child: Text(
        '완료',
        style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view_models/change_password_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordProvider);

    return DefaultLayout(
      title: '비밀번호 변경',
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        '현재 비밀번호',
                        style: AppTextStyles.body1.copyWith(
                          color: GRAY800_COLOR,
                        ),
                      ),
                      8.verticalSpace,
                      _buildPasswordField(
                        controller: _currentPasswordController,
                        hintText: '현재 비밀번호 입력',
                      ),
                      24.verticalSpace,
                      Text(
                        '새 비밀번호',
                        style: AppTextStyles.body1.copyWith(
                          color: GRAY800_COLOR,
                        ),
                      ),
                      8.verticalSpace,
                      _buildPasswordField(
                        controller: _newPasswordController,
                        hintText: '6자 이상 입력(영문+숫자)',
                      ),
                      24.verticalSpace,
                      Text(
                        '새 비밀번호 확인',
                        style: AppTextStyles.body1.copyWith(
                          color: GRAY800_COLOR,
                        ),
                      ),
                      8.verticalSpace,
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hintText: '새 비밀번호 확인',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(changePasswordProvider.notifier).changePassword(
                      currentPassword: _currentPasswordController.text,
                      newPassword: _newPasswordController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BLUE400_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: state.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  '변경하기',
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body1.copyWith(
          color: GRAY400_COLOR,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: GRAY200_COLOR),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: GRAY200_COLOR),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: BLUE400_COLOR),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '비밀번호를 입력해주세요.';
        }
        if (controller == _newPasswordController) {
          if (value.length < 6) {
            return '비밀번호는 6자 이상이어야 합니다.';
          }
          if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
            return '영문과 숫자를 모두 포함해야 합니다.';
          }
        }
        if (controller == _confirmPasswordController) {
          if (value != _newPasswordController.text) {
            return '비밀번호가 일치하지 않습니다.';
          }
        }
        return null;
      },
    );
  }
}
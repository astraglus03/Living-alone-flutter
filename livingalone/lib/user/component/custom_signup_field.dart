import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomSignupField extends StatelessWidget {
  final controller;
  final String hintText;
  final TextInputType type;
  final String validateText;
  final String subTitle;
  final String submitButtonTitle;
  final double width;
  final VoidCallback onTap;
  final FocusNode? focusNode;
  final VoidCallback onTextFieldTap;
  final VoidCallback onPressed;


  const CustomSignupField({
    required this.controller,
    required this.hintText,
    required this.type,
    super.key,
    required this.validateText,
    required this.subTitle,
    required this.submitButtonTitle,
    this.width = 106, // FIXME: 피그마 기준 104인데 106으로 설정해야함.
    required this.onTap,
    this.focusNode,
    required this.onTextFieldTap,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 345,
      // FIXME: 피그마 128인데 유효성 검사를 통해서 오류 띄우게 되면 20정도의 추가 공간이 필요한데 늘려도 괜찮을지. 20이면 딱 맞음.
      height: 148,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subTitle,
            style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            onTap: onTextFieldTap,
            cursorColor: BLUE400_COLOR,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed:onPressed,
                icon: Image.asset('assets/image/suffix_delete.png'),
              ),
              border: OutlineInputBorder(
                borderSide: baseBorder,
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: baseBorder),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: baseBorder,
              ),
              hintText: hintText,
              hintStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
            ),
            keyboardType: type,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$validateText 입력해주세요';
              }
              // 이메일 형식 검증 로직 추가 가능
              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: width,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BLUE100_COLOR,
                foregroundColor: BLUE400_COLOR,
                padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                shadowColor: Colors.transparent,
              ),
              onPressed: onTap,
              child: Text(submitButtonTitle,
              style: AppTextStyles.body1.copyWith(color: BLUE400_COLOR),
            ),),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomPriceField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final double? width;
  final Color? texFieldBackgroundColor;
  final String? units;
  final TextInputType? keyboardType;

  const CustomPriceField({
    required this.label,
    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.validator,
    super.key,
    this.width,
    this.texFieldBackgroundColor,
    this.units,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
        ),
        10.verticalSpace,
        Container(
          width: width ?? 313.w,
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 16).r,
          decoration: BoxDecoration(
            color: texFieldBackgroundColor ?? WHITE100_COLOR,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  scrollPadding: EdgeInsets.only(bottom: 160.h),
                  keyboardType: keyboardType ?? TextInputType.number,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.title.copyWith(
                    color: GRAY800_COLOR,
                  ),
                  inputFormatters: [
                    if (keyboardType == null) FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: AppTextStyles.title.copyWith(
                      color: GRAY400_COLOR,
                    ),
                  ),
                  onFieldSubmitted: (_) => onSubmitted?.call(),
                  validator: validator,
                  onChanged: onChanged,
                ),
              ),
              Text(
                units ?? '만원',
                style: AppTextStyles.title.copyWith(
                  color: GRAY800_COLOR,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 
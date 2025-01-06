import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomSelectList<T> extends StatelessWidget {
  final List<String> items;
  final dynamic selected;  // String? 또는 List<String>
  final Function(String) onItemSelected;
  final bool showError;
  final String? errorText;
  final bool multiSelect;  // 다중 선택 여부
  final int? maxSelect;    // 최대 선택 가능 개수

  const CustomSelectList({
    required this.items,
    required this.selected,
    required this.onItemSelected,
    this.showError = false,
    this.errorText,
    this.multiSelect = false,  // 기본값은 단일 선택
    this.maxSelect,
    Key? key,
  }) : assert(
         multiSelect ? selected is List<String> : selected is String?,
         'multiSelect가 true면 selected는 List<String>이어야 하고, '
         'false면 selected는 String?이어야 합니다.',
       ),
       assert(
         maxSelect == null || multiSelect,
         'maxSelect는 multiSelect가 true일 때만 사용할 수 있습니다.',
       ),
       super(key: key);

  bool _isSelected(String item) {
    if (multiSelect) {
      return (selected as List<String>).contains(item);
    } else {
      return selected == item;
    }
  }

  bool _isDisabled(String item) {
    if (!multiSelect) return false;
    if (maxSelect == null) return false;
    return !_isSelected(item) && (selected as List<String>).length >= maxSelect!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          items.length,
          (index) {
            final item = items[index];
            final isSelected = _isSelected(item);
            final isDisabled = _isDisabled(item);

            return Column(
              children: [
                GestureDetector(
                  onTap: isDisabled ? null : () => onItemSelected(item),
                  child: Container(
                    width: 345.w,
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                    decoration: BoxDecoration(
                      color: isSelected ? BLUE100_COLOR : GRAY100_COLOR,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? BLUE400_COLOR : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: AppTextStyles.subtitle.copyWith(
                        color: GRAY800_COLOR,
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
              ],
            );
          },
        ),
        if (showError)
          ShowErrorText(errorText: errorText!),
      ],
    );
  }
} 
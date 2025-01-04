import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomSelectList extends StatelessWidget {
  final List<String> items;
  final dynamic selected;  // String? 또는 List<String>
  final Function(String) onItemSelected;
  final bool showError;
  final String errorText;
  final bool multiSelect;  // 복수 선택 여부

  const CustomSelectList({
    required this.items,
    required this.selected,
    required this.onItemSelected,
    this.showError = false,
    this.errorText = '항목을 선택해 주세요.',
    this.multiSelect = false,  // 기본값은 단일 선택
    super.key,
  });

  bool _isSelected(String item) {
    if (multiSelect) {
      return (selected as List<String>).contains(item);
    } else {
      return selected == item;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          items.length,
          (index) {
            final item = items[index];
            final isSelected = _isSelected(item);
            
            return Column(
              children: [
                GestureDetector(
                  onTap: () => onItemSelected(item),
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
          ShowErrorText(errorText: errorText),
      ],
    );
  }
} 
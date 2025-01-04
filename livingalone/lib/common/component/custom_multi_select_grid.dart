import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

class CustomMultiSelectGrid extends StatelessWidget {
  final String label;  // 옵션, 시설
  final List<String> items;  // 선택 가능한 항목들
  final List<String> selectedItems;  // 선택된 항목들
  final Function(String) onItemSelected;  // 항목 선택/해제 콜백

  const CustomMultiSelectGrid({
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onItemSelected,
    super.key,
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
        16.verticalSpace,
        Wrap(
          spacing: 8.w,  // 가로 간격
          runSpacing: 8.h,  // 세로 간격
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            
            return GestureDetector(
              onTap: () => onItemSelected(item),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? BLUE100_COLOR : WHITE100_COLOR,
                  borderRadius: BorderRadius.circular(40).r,
                  border: Border.all(
                    color: isSelected ? BLUE400_COLOR : GRAY300_COLOR,
                    width: 1,
                  ),
                ),
                child: Text(
                  item,
                  style: AppTextStyles.body2.copyWith(
                    color: isSelected ? BLUE400_COLOR : GRAY500_COLOR,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
} 
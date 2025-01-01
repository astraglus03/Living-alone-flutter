import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';

class CustomFilterButton extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final VoidCallback onPressed;
  final bool selected;

  const CustomFilterButton({
    required this.label,
    required this.onPressed,
    this.selectedValue,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: selected ? GRAY200_COLOR : Colors.white, elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey[200]!,
              width: 1.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyles.caption2),
            if (selectedValue != null) ...[
              SizedBox(width: 4),
              SizedBox(
                height: 16,
                child: VerticalDivider(
                  thickness: 1,
                  width: 8,
                  color: GRAY200_COLOR,
                ),
              ),
              SizedBox(width: 4),
              Text(selectedValue!, style: AppTextStyles.caption2),
            ],
            SizedBox(width: 4),
            SvgPicture.asset(
              'assets/image/down.svg',
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

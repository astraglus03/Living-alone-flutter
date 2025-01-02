import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';

class CommonCheckboxOption extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showDivider;

  const CommonCheckboxOption({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.065, vertical: 14),
          child: InkWell(
            onTap: () => onChanged(!value),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: value ? BLUE400_COLOR : GRAY300_COLOR,
                        width: 2,
                      ),
                    ),
                    child: value
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: BLUE400_COLOR,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 8),
                Text(text, style: AppTextStyles.body2),
              ],
            ),
          ),
        ),
        if (showDivider)
          DottedLine(
            direction: Axis.horizontal,
            dashGapLength: 0,
            alignment: WrapAlignment.center,
            dashColor: GRAY200_COLOR,
            lineLength: MediaQuery.of(context).size.width * 0.87,
            lineThickness: 1.0,
          )
      ],
    );
  }
}
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';

class CommonRadioOption extends StatelessWidget {
  final String text;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final bool showDivider;

  const CommonRadioOption({
    Key? key,
    required this.text,
    required this.groupValue,
    required this.onChanged,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Radio<String>(
                value: text,
                groupValue: groupValue,
                onChanged: onChanged,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return BLUE400_COLOR;
                    }
                    return GRAY300_COLOR;
                  },
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(text, style: AppTextStyles.body2),
            ],
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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';

// Blur처리 및 옵션 메뉴 선택
class OptionMenuItem {
  final String text;
  final String icon;
  final VoidCallback onTap;

  OptionMenuItem({
    required this.text,
    required this.icon,
    required this.onTap,

  });
}

class OptionsMenu {
  static Future<void> show({
    required BuildContext context,
    required List<OptionMenuItem> options,
    Offset? position,
  }) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Stack(
            children: [
              Positioned(
                top: position?.dy ?? 56.h,
                left: position?.dx ?? 201.w,
                child: Container(
                  width: 180.w,
                  height: options.length * 45.h,
                  decoration: BoxDecoration(
                    color: WHITE100_COLOR,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isFirst = index == 0;
                      final isLast = index == options.length - 1;

                      // 마지막 항목일 경우 에러 색상 적용
                      final textStyle = isLast
                          ? AppTextStyles.body2.copyWith(
                        color: ERROR_TEXT_COLOR,
                        fontWeight: FontWeight.w500,
                      )
                          : AppTextStyles.body2.copyWith(
                        color: GRAY800_COLOR,
                        fontWeight: FontWeight.w500,
                      );
                      final iconColor = isLast ? ERROR_TEXT_COLOR : GRAY400_COLOR;

                      return Expanded(
                        child: Material(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: isFirst ? Radius.circular(10.r) : Radius.zero,
                              topRight: isFirst ? Radius.circular(10.r) : Radius.zero,
                              bottomLeft: isLast ? Radius.circular(10.r) : Radius.zero,
                              bottomRight: isLast ? Radius.circular(10.r) : Radius.zero,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              topLeft: isFirst ? Radius.circular(10.r) : Radius.zero,
                              topRight: isFirst ? Radius.circular(10.r) : Radius.zero,
                              bottomLeft: isLast ? Radius.circular(10.r) : Radius.zero,
                              bottomRight: isLast ? Radius.circular(10.r) : Radius.zero,
                            ),
                            hoverColor: BLUE200_COLOR,
                            splashColor: BLUE200_COLOR,
                            highlightColor: BLUE200_COLOR,
                            onTap: () {
                              Navigator.pop(context);
                              option.onTap();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 16.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    width: 18.w,
                                    height: 18.h,
                                    option.icon,
                                    colorFilter: isLast ? ColorFilter.mode(
                                      iconColor,
                                      BlendMode.srcIn,
                                    ): null,
                                  ),
                                  6.horizontalSpace,
                                  Text(
                                    option.text,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

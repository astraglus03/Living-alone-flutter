import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/const/text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const CustomSearchBar({
    required this.onNotificationTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
          height: 48,
          width: 306,
          child: TextField(
            style: AppTextStyles.body2,
            decoration: InputDecoration(
              hintText: '지역, 건물 이름 등 검색',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/image/search.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        SizedBox(width: 12),
        GestureDetector(
          onTap: onNotificationTap,
          child: SvgPicture.asset("assets/image/bell.svg"),
        ),
      ],
    );
  }
}

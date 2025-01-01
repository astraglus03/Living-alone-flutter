import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../component/filterchip.dart';

class BoardFilterChipList extends StatelessWidget {
  const BoardFilterChipList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            SvgPicture.asset('assets/image/FilterButton.svg'),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '지역',
              onPressed: () {  },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '종류',
              onPressed: () {  },
              selectedValue: "헬스",
            ),
          ],
        ),
      ),
    );
  }
}
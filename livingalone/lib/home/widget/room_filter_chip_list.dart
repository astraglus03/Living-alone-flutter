import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../component/filterchip.dart';


class RoomFilterChipList extends StatelessWidget {
  const RoomFilterChipList({Key? key}) : super(key: key);

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
              label: '입대 유형',
              onPressed: () {  },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '가격',
              onPressed: () {  },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '조건',
              onPressed: () {  },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '시설',
              onPressed: () {  },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/filterchip.dart';
import '../models/room_filter_model.dart';
import 'room_filter_modal.dart';
import '../view_models/room_filter_provider.dart';


class RoomFilterChipList extends ConsumerWidget {
  const RoomFilterChipList({Key? key}) : super(key: key);

  bool hasActiveFilters(FilterState state) {
    return state.locations.values.any((v) => v) ||
        state.buildingTypes.values.any((v) => v) ||
        state.propertyTypes.values.any((v) => v) ||
        state.rentalTypes.values.any((v) => v) ||
        state.depositRange != null ||
        state.monthlyRange != null ||
        state.facilities.values.any((v) => v) ||
        state.conditions.values.any((v) => v);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                hasActiveFilters(filterState) 
                    ? 'assets/image/Filter_Reset.svg'
                    : 'assets/image/FilterButton.svg',
              ),
              onTap: () {
                if (hasActiveFilters(filterState)) {
                  ref.read(filterProvider.notifier).resetFilter();
                } else {
                  showFilterBottomSheet(context);
                }
              },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '지역',
              selectedValue: filterState.selectedLocations,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '건물 유형',
              selectedValue: filterState.selectedBuildingTypes,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '매물 종류',
              selectedValue: filterState.selectedPropertyTypes,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '임대 방식',
              selectedValue: filterState.selectedRentalTypes,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '보증금',
              selectedValue: filterState.depositRangeText,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '월세',
              selectedValue: filterState.monthlyRangeText,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '시설',
              selectedValue: filterState.selectedFacilities,
              onPressed: () => showFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '조건',
              selectedValue: filterState.selectedConditions,
              onPressed: () => showFilterBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

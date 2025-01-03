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

  void _showFilterBottomSheetWithTab(BuildContext context, int tabIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FilterBottomSheet(initialTabIndex: tabIndex),
        ),
      ),
    );
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
                  _showFilterBottomSheetWithTab(context, 0);
                }
              },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '지역',
              selectedValue: filterState.selectedLocations,
              onPressed: () => _showFilterBottomSheetWithTab(context, 0),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '건물 유형',
              selectedValue: filterState.selectedBuildingTypes,
              onPressed: () => _showFilterBottomSheetWithTab(context, 1),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '매물 종류',
              selectedValue: filterState.selectedPropertyTypes,
              onPressed: () => _showFilterBottomSheetWithTab(context, 2),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '임대 방식',
              selectedValue: filterState.selectedRentalTypes,
              onPressed: () => _showFilterBottomSheetWithTab(context, 3),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '보증금',
              selectedValue: filterState.depositRangeText,
              onPressed: () => _showFilterBottomSheetWithTab(context, 4),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '월세',
              selectedValue: filterState.monthlyRangeText,
              onPressed: () => _showFilterBottomSheetWithTab(context, 4),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '시설',
              selectedValue: filterState.selectedFacilities,
              onPressed: () => _showFilterBottomSheetWithTab(context, 5),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '조건',
              selectedValue: filterState.selectedConditions,
              onPressed: () => _showFilterBottomSheetWithTab(context, 6),
            ),
          ],
        ),
      ),
    );
  }
}

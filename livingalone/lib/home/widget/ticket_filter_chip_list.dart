import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/filterchip.dart';
import '../models/ticket_filter_model.dart';
import '../view_models/ticket_filter_provider.dart';
import 'ticket_filter_modal.dart';

class BoardFilterChipList extends ConsumerWidget {
  const BoardFilterChipList({Key? key}) : super(key: key);

  bool hasActiveFilters(TicketFilterState state) {
    return state.locations.values.any((value) => value) ||
        state.ticketTypes.values.any((value) => value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(ticketFilterProvider);
    final hasFilters = hasActiveFilters(filterState);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                hasFilters
                    ? 'assets/image/Filter_Reset.svg'
                    : 'assets/image/FilterButton.svg',
              ),
              onTap: () {
                if (hasFilters) {
                  // 필터 초기화
                  ref.read(ticketFilterProvider.notifier).resetFilter();
                } else {
                  // 필터 모달 표시
                  showTicketFilterBottomSheet(context);
                }
              },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '지역',
              selectedValue: filterState.selectedLocations,
              onPressed: () => showTicketFilterBottomSheet(context),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '종류',
              selectedValue: filterState.selectedTicketTypes,
              onPressed: () => showTicketFilterBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
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

  void _showTicketFilterBottomSheetWithTab(BuildContext context, int tabIndex) {
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
          child: TicketFilterBottomSheet(initialTabIndex: tabIndex),
        ),
      ),
    );
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
                  ref.read(ticketFilterProvider.notifier).resetFilter();
                } else {
                  _showTicketFilterBottomSheetWithTab(context, 0);
                }
              },
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '지역',
              selectedValue: filterState.selectedLocations,
              onPressed: () => _showTicketFilterBottomSheetWithTab(context, 0),
            ),
            SizedBox(width: 4),
            CustomFilterButton(
              label: '종류',
              selectedValue: filterState.selectedTicketTypes,
              onPressed: () => _showTicketFilterBottomSheetWithTab(context, 1),
            ),
          ],
        ),
      ),
    );
  }
}
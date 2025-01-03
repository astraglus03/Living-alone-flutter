import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';
import '../../home/component/checkbox_likeradio.dart';
import '../models/ticket_filter_model.dart';
import '../view_models/ticket_filter_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showTicketFilterBottomSheet(BuildContext context) {
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
        child: TicketFilterBottomSheet(),
      ),
    ),
  );
}

class TicketFilterBottomSheet extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const TicketFilterBottomSheet({
    Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  _TicketFilterBottomSheetState createState() => _TicketFilterBottomSheetState();
}

class _TicketFilterBottomSheetState extends ConsumerState<TicketFilterBottomSheet> {
  late int selectedTabIndex;
  final List<String> tabs = ['지역', '이용권 종류'];
  late TicketFilterState currentFilter;

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.initialTabIndex;
    currentFilter = ref.read(ticketFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          _buildHeader(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTabs(),
            ],
          ),
          SizedBox(height: 12),
          _buildTabContent(selectedTabIndex),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRefreshButton(),
                SizedBox(width: 8),
                _buildConfirmButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 50),
        Text('필터', style: AppTextStyles.title.copyWith(color: GRAY800_COLOR)),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 18),
          Row(
            children: List.generate(
              tabs.length,
                  (index) => _buildTab(
                tabs[index],
                isSelected: selectedTabIndex == index,
                onTap: () => setState(() => selectedTabIndex = index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? BLUE400_COLOR : GRAY100_COLOR,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          text,
          style: AppTextStyles.subtitle.copyWith(
            color: isSelected ? WHITE100_COLOR : GRAY600_COLOR,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _LocationFilter();
      case 1:
        return _TicketTypeFilter();
      default:
        return Container();
    }
  }

  Widget _buildRefreshButton() {
    return GestureDetector(
      child: Container(
          width: 50,
          height: 50,
          child: SvgPicture.asset('assets/image/XS.svg')
      ),
      onTap: (){setState(() {
        currentFilter = TicketFilterState();
      });},
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: 287,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          ref.read(ticketFilterProvider.notifier).updateFilter(currentFilter);
          Navigator.pop(context);
        },
        child: Text('적용하기', style: AppTextStyles.title.copyWith(color: WHITE100_COLOR)),
        style: ElevatedButton.styleFrom(
          backgroundColor: BLUE400_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void updateFilter({
    Map<String, bool>? locations,
    Map<String, bool>? ticketTypes,
  }) {
    setState(() {
      currentFilter = currentFilter.copyWith(
        locations: locations,
        ticketTypes: ticketTypes,
      );
    });
  }
}

class _LocationFilter extends ConsumerStatefulWidget {
  @override
  _LocationFilterState createState() => _LocationFilterState();
}

class _LocationFilterState extends ConsumerState<_LocationFilter> {
  @override
  Widget build(BuildContext context) {
    final locations = context.findAncestorStateOfType<_TicketFilterBottomSheetState>()
        ?.currentFilter.locations ?? {};

    return Column(
      children: locations.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedLocations = Map<String, bool>.from(locations);
            updatedLocations[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_TicketFilterBottomSheetState>()?.updateFilter(
              locations: updatedLocations,
            );
          },
          showDivider: entry.key != locations.keys.last,
        );
      }).toList(),
    );
  }
}

class _TicketTypeFilter extends ConsumerStatefulWidget {
  @override
  _TicketTypeFilterState createState() => _TicketTypeFilterState();
}

class _TicketTypeFilterState extends ConsumerState<_TicketTypeFilter> {
  @override
  Widget build(BuildContext context) {
    final ticketTypes = context.findAncestorStateOfType<_TicketFilterBottomSheetState>()
        ?.currentFilter.ticketTypes ?? {};

    return Column(
      children: ticketTypes.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedTypes = Map<String, bool>.from(ticketTypes);
            updatedTypes[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_TicketFilterBottomSheetState>()?.updateFilter(
              ticketTypes: updatedTypes,
            );
          },
          showDivider: entry.key != ticketTypes.keys.last,
        );
      }).toList(),
    );
  }
}
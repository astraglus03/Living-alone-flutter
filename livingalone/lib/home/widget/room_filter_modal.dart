import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';

import '../../common/const/colors.dart';
import '../component/checkbox_likeradio.dart';
import '../component/radio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_filter_model.dart';
import '../view_models/room_filter_provider.dart';

void showFilterBottomSheet(BuildContext context) {
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
        child: FilterBottomSheet(),
      ),
    ),
  );
}

class FilterBottomSheet extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const FilterBottomSheet({
    Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late int selectedTabIndex;
  final List<String> tabs = ['지역', '건물 유형', '매물 종류', '임대 방식', '가격', '시설', '조건'];
  late FilterState currentFilter;

  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.initialTabIndex;
    currentFilter = ref.read(filterProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          _buildHeader(),
          _buildTabs(),
          SizedBox(height: 12),
          _buildTabContent(selectedTabIndex),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 공백 채우는용
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRefreshBottomButton(),
                SizedBox(width: 8),
                _buildBottomButton(),
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
        SizedBox(
          width: 50,
        ),
        Text(
          '필터',
          style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
        ),
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
          SizedBox(
            width: 18,
          ),
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

  Widget _buildTab(String text,
      {bool isSelected = false, VoidCallback? onTap}) {
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
    print('Selected tab index: $index');
    switch (index) {
      case 0:
        return _LocationFilter();
      case 1:
        return _BuildingTypeFilter();
      case 2:
        return _PropertyTypeFilter();
      case 3:
        return _RentalTypeFilter();
      case 4:
        return _PriceRangeFilter();
      case 5:
        print('Rendering Facility Filter');
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _FacilityFilter(),
        );
      case 6:
        return _ConditionFilter();
      default:
        return Container();
    }
  }

  Widget _buildRefreshBottomButton() {
    return GestureDetector(
      child: Container(
          width: 50,
          height: 50,
          child: SvgPicture.asset('assets/image/XS.svg')
      ),
      onTap: (){setState(() {
        currentFilter = FilterState();
      });},
    );
  }




  Widget _buildBottomButton() {
    return Container(
      width: 287,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          ref.read(filterProvider.notifier).updateFilter(currentFilter);
          Navigator.pop(context);
        },
        child: Text('매물보기', style: AppTextStyles.title.copyWith(color: WHITE100_COLOR)),
        style: ElevatedButton.styleFrom(
          backgroundColor: BLUE400_COLOR,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void updateFilter({
    Map<String, bool>? locations,
    Map<String, bool>? buildingTypes,
    Map<String, bool>? propertyTypes,
    Map<String, bool>? rentalTypes,
    RangeValues? depositRange,
    RangeValues? monthlyRange,
    Map<String, bool>? facilities,
    Map<String, bool>? conditions,
  }) {
    setState(() {
      currentFilter = currentFilter.copyWith(
        locations: locations,
        buildingTypes: buildingTypes,
        propertyTypes: propertyTypes,
        rentalTypes: rentalTypes,
        depositRange: depositRange,
        monthlyRange: monthlyRange,
        facilities: facilities,
        conditions: conditions,
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
    final locations = context.findAncestorStateOfType<_FilterBottomSheetState>()
        ?.currentFilter.locations ?? {};

    return Column(
      children: locations.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedLocations = Map<String, bool>.from(locations);
            updatedLocations[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              locations: updatedLocations,
            );
          },
          showDivider: entry.key != locations.keys.last,
        );
      }).toList(),
    );
  }
}

class _BuildingTypeFilter extends ConsumerStatefulWidget {
  @override
  _BuildingTypeFilterState createState() => _BuildingTypeFilterState();
}

class _BuildingTypeFilterState extends ConsumerState<_BuildingTypeFilter> {
  @override
  Widget build(BuildContext context) {
    final buildingTypes = context.findAncestorStateOfType<_FilterBottomSheetState>()
        ?.currentFilter.buildingTypes ?? {};

    return Column(
      children: buildingTypes.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedTypes = Map<String, bool>.from(buildingTypes);
            updatedTypes[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              buildingTypes: updatedTypes,
            );
          },
          showDivider: entry.key != buildingTypes.keys.last,
        );
      }).toList(),
    );
  }
}

class _PropertyTypeFilter extends ConsumerStatefulWidget {
  @override
  _PropertyTypeFilterState createState() => _PropertyTypeFilterState();
}

class _PropertyTypeFilterState extends ConsumerState<_PropertyTypeFilter> {
  @override
  Widget build(BuildContext context) {
    final propertyTypes = context.findAncestorStateOfType<_FilterBottomSheetState>()
        ?.currentFilter.propertyTypes ?? {};

    return Column(
      children: propertyTypes.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedTypes = Map<String, bool>.from(propertyTypes);
            updatedTypes[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              propertyTypes: updatedTypes,
            );
          },
          showDivider: entry.key != propertyTypes.keys.last,
        );
      }).toList(),
    );
  }
}

class _RentalTypeFilter extends ConsumerStatefulWidget {
  @override
  _RentalTypeFilterState createState() => _RentalTypeFilterState();
}

class _RentalTypeFilterState extends ConsumerState<_RentalTypeFilter> {
  @override
  Widget build(BuildContext context) {
    final rentalTypes = context.findAncestorStateOfType<_FilterBottomSheetState>()
        ?.currentFilter.rentalTypes ?? {};

    return Column(
      children: rentalTypes.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedTypes = Map<String, bool>.from(rentalTypes);
            updatedTypes[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              rentalTypes: updatedTypes,
            );
          },
          showDivider: entry.key != rentalTypes.keys.last,
        );
      }).toList(),
    );
  }
}

class _PriceRangeFilter extends ConsumerStatefulWidget {
  @override
  _PriceRangeFilterState createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends ConsumerState<_PriceRangeFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12,),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('보증금', style: AppTextStyles.body2),
                          SizedBox(height: 4),
                          Center(
                            child: IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: BLUE100_COLOR,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                      _getDepositRangeText(context.findAncestorStateOfType<_FilterBottomSheetState>()?.currentFilter.depositRange ?? RangeValues(0, 10000)),
                                      style: AppTextStyles.caption2.copyWith(color: BLUE400_COLOR)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          rangeThumbShape: RoundRangeSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          activeTrackColor: BLUE400_COLOR,
                          inactiveTrackColor: BLUE100_COLOR,
                          thumbColor: BLUE400_COLOR,
                          overlayColor: Colors.blue.withOpacity(0.3),
                        ),
                        child: RangeSlider(
                          values: context.findAncestorStateOfType<_FilterBottomSheetState>()?.currentFilter.depositRange ?? RangeValues(0, 10000),
                          min: 0,
                          max: 10000,
                          divisions: 100,
                          onChanged: (RangeValues values) {
                            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
                              depositRange: values,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0만원', style: AppTextStyles.caption3),
                          Text('1억 이상', style: AppTextStyles.caption3),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('월세', style: AppTextStyles.body2),
                          SizedBox(height: 4),
                          Center(
                            child: IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: BLUE100_COLOR,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                      _getMonthlyRangeText(context.findAncestorStateOfType<_FilterBottomSheetState>()?.currentFilter.monthlyRange ?? RangeValues(0, 100)),
                                      style: AppTextStyles.caption2.copyWith(color: BLUE400_COLOR)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          rangeThumbShape: RoundRangeSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          activeTrackColor: BLUE400_COLOR,
                          inactiveTrackColor: BLUE100_COLOR,
                          thumbColor: BLUE400_COLOR,
                          overlayColor: Colors.blue.withOpacity(0.3),
                        ),
                        child: RangeSlider(
                          values: context.findAncestorStateOfType<_FilterBottomSheetState>()?.currentFilter.monthlyRange ?? RangeValues(0, 100),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: (RangeValues values) {
                            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
                              monthlyRange: values,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0만원', style: AppTextStyles.caption3),
                          Text('100만원 이상', style: AppTextStyles.caption3),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDepositRangeText(RangeValues values) {
    String formatDeposit(double value) {
      if (value >= 10000) {
        return '${(value/10000).toStringAsFixed(0)}억원';
      }
      return '${value.round()}만원';
    }

    if (values.start == 0 && values.end == 10000) {
      return '전체';
    } else if (values.start == 0) {
      return '${formatDeposit(values.end)} 이하';
    } else {
      return '${formatDeposit(values.start)}~${formatDeposit(values.end)}';
    }
  }

  String _getMonthlyRangeText(RangeValues values) {
    if (values.start == 0 && values.end == 100) {
      return '전체';
    } else if (values.start == 0) {
      return '${values.end.round()}만원 이하';
    } else {
      return '${values.start.round()}만원~${values.end.round()}만원';
    }
  }
}

class _FacilityFilter extends ConsumerStatefulWidget {
  const _FacilityFilter({Key? key}) : super(key: key);

  @override
  _FacilityFilterState createState() => _FacilityFilterState();
}

class _FacilityFilterState extends ConsumerState<_FacilityFilter> {
  @override
  Widget build(BuildContext context) {
    final facilities = context.findAncestorStateOfType<_FilterBottomSheetState>()?.currentFilter.facilities ?? {};

    return Column(
      children: facilities.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedFacilities = Map<String, bool>.from(facilities);
            updatedFacilities[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              facilities: updatedFacilities,
            );
          },
        );
      }).toList(),
    );
  }
}

class _ConditionFilter extends ConsumerStatefulWidget {
  @override
  _ConditionFilterState createState() => _ConditionFilterState();
}

class _ConditionFilterState extends ConsumerState<_ConditionFilter> {
  @override
  Widget build(BuildContext context) {
    final conditions = context.findAncestorStateOfType<_FilterBottomSheetState>()
        ?.currentFilter.conditions ?? {};

    return Column(
      children: conditions.entries.map((entry) {
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            final updatedConditions = Map<String, bool>.from(conditions);
            updatedConditions[entry.key] = newValue ?? false;
            context.findAncestorStateOfType<_FilterBottomSheetState>()?.updateFilter(
              conditions: updatedConditions,
            );
          },
          showDivider: entry.key != conditions.keys.last,
        );
      }).toList(),
    );
  }
}

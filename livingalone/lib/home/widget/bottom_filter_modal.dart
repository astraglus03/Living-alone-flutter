import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:livingalone/common/const/text_styles.dart';

import '../../common/const/colors.dart';
import '../component/checkbox_likeradio.dart';
import '../component/radio.dart';

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

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['지역', '건물 유형', '매물 종류', '임대 방식', '가격', '시설'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10,),
          _buildHeader(),
          _buildTabs(),
          SizedBox(height: 12),
        _buildTabContent(selectedTabIndex),
          _buildBottomButton(),

        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 50,),
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
            SizedBox(width: 18,),
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
        child:  Text(
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
        return _BuildingTypeFilter();
      case 2:
        return _PropertyTypeFilter();
      case 3:
        return _RentalTypeFilter();
      case 4:
        return _PriceRangeFilter();
      case 5:
        return _FacilityFilter();
      default:
        return Container();
    }
  }

  Widget _buildBottomButton() {
    return ElevatedButton(
      onPressed: () {
        // 필터 적용 로직
        Navigator.pop(context);
      },
      child: Text('매물보기'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[400],
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}



class _LocationFilter extends StatefulWidget {
  @override
  _LocationFilterState createState() => _LocationFilterState();
}

class _LocationFilterState extends State<_LocationFilter> {
  String selectedLocation = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonRadioOption(
          text: '안심동',
          groupValue: selectedLocation,
          onChanged: (value) => setState(() => selectedLocation = value!),
        ),
        CommonRadioOption(
          text: '신부동',
          groupValue: selectedLocation,
          onChanged: (value) => setState(() => selectedLocation = value!),
        ),
        CommonRadioOption(
          text: '두정동',
          groupValue: selectedLocation,
          onChanged: (value) => setState(() => selectedLocation = value!),
          showDivider: false, // 마지막 항목은 구분선 없음
        ),
      ],
    );
  }
}

class _BuildingTypeFilter extends StatefulWidget {
  @override
  _BuildingTypeFilterState createState() => _BuildingTypeFilterState();
}

class _BuildingTypeFilterState extends State<_BuildingTypeFilter> {
  String selectedType = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonRadioOption(
          text: '빌라',
          groupValue: selectedType,
          onChanged: (value) => setState(() => selectedType = value!),
        ),
        CommonRadioOption(
          text: '원룸',
          groupValue: selectedType,
          onChanged: (value) => setState(() => selectedType = value!),
        ),
        CommonRadioOption(
          text: '오피스텔',
          groupValue: selectedType,
          onChanged: (value) => setState(() => selectedType = value!),
          showDivider: false,
        ),
      ],
    );
  }
}

class _PropertyTypeFilter extends StatefulWidget {
  @override
  _PropertyTypeFilterState createState() => _PropertyTypeFilterState();
}

class _PropertyTypeFilterState extends State<_PropertyTypeFilter> {
  String selectedProperty = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonRadioOption(
          text: '매물(신축)',
          groupValue: selectedProperty,
          onChanged: (value) => setState(() => selectedProperty = value!),
        ),
        CommonRadioOption(
          text: '매물(구축)',
          groupValue: selectedProperty,
          onChanged: (value) => setState(() => selectedProperty = value!),
          showDivider: false,
        ),
      ],
    );
  }
}

class _RentalTypeFilter extends StatefulWidget {
  @override
  _RentalTypeFilterState createState() => _RentalTypeFilterState();
}

class _RentalTypeFilterState extends State<_RentalTypeFilter> {
  String selectedRental = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonRadioOption(
          text: '전체',
          groupValue: selectedRental,
          onChanged: (value) => setState(() => selectedRental = value!),
        ),
        CommonRadioOption(
          text: '월세',
          groupValue: selectedRental,
          onChanged: (value) => setState(() => selectedRental = value!),
          showDivider: false,
        ),
      ],
    );
  }
}

class _PriceRangeFilter extends StatefulWidget {
  @override
  _PriceRangeFilterState createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<_PriceRangeFilter> {
  RangeValues _depositValues = RangeValues(0, 1000);
  RangeValues _monthlyValues = RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('보증금', style: AppTextStyles.body2),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
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
                              values: _depositValues,
                              min: 0,
                              max: 1000,
                              divisions: 100,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _depositValues = values;
                                });
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('월세', style: AppTextStyles.body2),
                            ],
                          ),
                        ),

                        SizedBox(height: 8),
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
                              values: _monthlyValues,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _monthlyValues = values;
                                });
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
}

class _FacilityFilter extends StatefulWidget {
  @override
  _FacilityFilterState createState() => _FacilityFilterState();
}

class _FacilityFilterState extends State<_FacilityFilter> {
  Map<String, bool> facilities = {
    '주차가능': false,
    '엘리베이터': false,
    'CCTV': false,
    '애완동물': false,
  };

  @override
  Widget build(BuildContext context) {
    final facilityList = facilities.entries.toList();
    
    return Column(
      children: List.generate(facilityList.length, (index) {
        final entry = facilityList[index];
        final isLast = index == facilityList.length - 1;
        
        return CommonCheckboxOption(
          text: entry.key,
          value: entry.value,
          onChanged: (bool? newValue) {
            setState(() {
              facilities[entry.key] = !(facilities[entry.key] ?? false);
            });
          },
          showDivider: !isLast,
        );
      }),
    );
  }
}

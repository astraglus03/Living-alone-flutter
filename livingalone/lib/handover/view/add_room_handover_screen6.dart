import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/component/custom_multi_select_grid.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
import 'package:livingalone/handover/view/add_room_handover_screen7.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRoomHandoverScreen6 extends ConsumerStatefulWidget {
  const AddRoomHandoverScreen6 ({super.key});

  @override
  ConsumerState<AddRoomHandoverScreen6> createState() => _AddRoomHandoverScreen6State();
}

class _AddRoomHandoverScreen6State extends ConsumerState<AddRoomHandoverScreen6> {
  final areaController = TextEditingController();
  final currentFloorController = TextEditingController();
  final totalFloorController = TextEditingController();

  final areaFocus = FocusNode();
  final currentFloorFocus = FocusNode();
  final totalFloorFocus = FocusNode();

  // 각 섹션별 에러 메시지
  String? areaError;
  String? floorError;
  String? optionsError;
  String? facilitiesError;
  String? conditionsError;

  // 선택된 항목들
  final List<String> selectedOptions = [];
  final List<String> selectedFacilities = [];
  final List<String> selectedConditions = [];

  void _validateInputs() {
    bool isValid = true;
    
    // setState로 에러 상태 업데이트
    setState(() {
      // 모든 에러 초기화
      areaError = null;
      floorError = null;

      // 면적 검증
      if (areaController.text.trim().isEmpty) {
        areaError = '면적을 입력해 주세요';
        isValid = false;
      }

      // 층수 검증
      if (currentFloorController.text.trim().isEmpty || totalFloorController.text.trim().isEmpty) {
        floorError = '층수를 입력해 주세요';
        isValid = false;
      }
    });

    // 검증 통과한 경우에만 Provider 업데이트 및 네비게이션
    if (isValid) {
      // Provider에 데이터 저장
      ref.read(roomHandoverProvider.notifier).update(
        area: areaController.text.trim(),
        currentFloor: currentFloorController.text.trim(),
        totalFloor: totalFloorController.text.trim(),
      );

      // 선택된 옵션들 저장
      for (final optionLabel in selectedOptions) {
        final option = RoomOption.values.firstWhere(
          (e) => e.label == optionLabel,
        );
        ref.read(roomHandoverProvider.notifier).toggleOption(option);
      }

      // 선택된 시설들 저장
      for (final facilityLabel in selectedFacilities) {
        final facility = Facility.values.firstWhere(
          (e) => e.label == facilityLabel,
        );
        ref.read(roomHandoverProvider.notifier).toggleFacility(facility);
      }

      // 선택된 조건들 저장
      for (final conditionLabel in selectedConditions) {
        final condition = RoomCondition.values.firstWhere(
          (e) => e.label == conditionLabel,
        );
        ref.read(roomHandoverProvider.notifier).toggleCondition(condition);
      }

      final currentRentType = ref.read(roomHandoverProvider).rentType;
      if (currentRentType == null) {
        // rentType이 없는 경우 에러 처리
        print('Error: rentType is not set');
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddRoomHandoverScreen7(rentType: currentRentType),
        ),
      );
    }
  }

  void _handleOptionSelected(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
      optionsError = null;
    });
  }

  void _handleFacilitySelected(String facility) {
    setState(() {
      if (selectedFacilities.contains(facility)) {
        selectedFacilities.remove(facility);
      } else {
        selectedFacilities.add(facility);
      }
      facilitiesError = null;
    });
  }

  void _handleConditionsSelected(String conditions) {
    setState(() {
      if (selectedConditions.contains(conditions)) {
        selectedConditions.remove(conditions);
      } else {
        selectedConditions.add(conditions);
      }
      conditionsError = null;
    });
  }


  @override
  void dispose() {
    areaController.dispose();
    currentFloorController.dispose();
    totalFloorController.dispose();
    areaFocus.dispose();
    currentFloorFocus.dispose();
    totalFloorFocus.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      currentStep: 6,
      totalSteps: 8,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        '방의 구체적인 정보를 입력해 주세요',
                        style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                      ),
                      20.verticalSpace,
                      CustomPriceField(
                        width: 345.w,
                        label: '면적',
                        units: '평',
                        texFieldBackgroundColor: GRAY100_COLOR,
                        controller: areaController,
                        focusNode: areaFocus,
                        onChanged: (_) {
                          if (areaError != null) {
                            setState(() {
                              areaError = null;
                            });
                          }
                        },
                        onSubmitted: () => FocusScope.of(context).requestFocus(totalFloorFocus),
                      ),
                      if (areaError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10).w,
                          child: ShowErrorText(errorText: areaError!),
                        ),
                      14.verticalSpace,
                      Divider(
                        color: GRAY200_COLOR,
                      ),
                      14.verticalSpace,
                      Row(
                        children: [
                          CustomPriceField(
                            width: 168.w,
                            texFieldBackgroundColor: GRAY100_COLOR,
                            label: '해당 층',
                            controller: currentFloorController,
                            focusNode: currentFloorFocus,
                            units: '층',
                            onChanged: (_) {
                              if (floorError != null) {
                                setState(() {
                                  floorError = null;
                                });
                              }
                            },
                          ),
                          9.horizontalSpace,
                          CustomPriceField(
                            width: 168.w,
                            texFieldBackgroundColor: GRAY100_COLOR,
                            label: '전체 층',
                            controller: totalFloorController,
                            focusNode: totalFloorFocus,
                            units: '층',
                            onChanged: (_) {
                              if (floorError != null) {
                                setState(() {
                                  floorError = null;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      if (floorError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10).w,
                          child: ShowErrorText(errorText: floorError!),
                        ),
                      14.verticalSpace,
                      Divider(
                        color: GRAY200_COLOR,
                      ),
                      14.verticalSpace,
                      CustomMultiSelectGrid(
                        label: '옵션',
                        items: RoomOption.values.map((e)=> e.label).toList(),
                        selectedItems: selectedOptions,
                        onItemSelected: _handleOptionSelected,
                      ),
                      if (optionsError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10).w,
                          child: ShowErrorText(errorText: optionsError!),
                        ),
                      14.verticalSpace,
                      Divider(
                        color: GRAY200_COLOR,
                      ),
                      14.verticalSpace,
                      CustomMultiSelectGrid(
                        label: '시설',
                        items: Facility.values.map((e) => e.label).toList(),
                        selectedItems: selectedFacilities,
                        onItemSelected: _handleFacilitySelected,
                      ),
                      if (facilitiesError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10).w,
                          child: ShowErrorText(errorText: facilitiesError!),
                        ),
                      14.verticalSpace,
                      Divider(
                        color: GRAY200_COLOR,
                      ),
                      14.verticalSpace,
                      CustomMultiSelectGrid(
                        label: '조건',
                        items: RoomCondition.values.map((e) => e.label).toList(),
                        selectedItems: selectedConditions,
                        onItemSelected: _handleConditionsSelected,
                      ),
                      if (conditionsError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 10).w,
                          child: ShowErrorText(errorText: conditionsError!),
                        ),
                      120.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: _validateInputs,
          ),
        ],
      ),
    );
  }
}

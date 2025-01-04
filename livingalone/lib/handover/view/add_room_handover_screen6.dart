import 'package:flutter/material.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/component/custom_multi_select_grid.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
import 'package:livingalone/handover/view/add_room_handover_screen7.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRoomHandoverScreen6 extends StatefulWidget {
  const AddRoomHandoverScreen6 ({super.key});

  @override
  State<AddRoomHandoverScreen6> createState() => _AddRoomHandoverScreen6State();
}

class _AddRoomHandoverScreen6State extends State<AddRoomHandoverScreen6> {
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

  // 옵션 목록
  final List<String> options = [
    '세탁기', '건조기', '냉장고', '에어컨',
    '공기순환기', '전자레인지', '가스레인지',
    '인덕션', '침대', '책상', '의자', '옷장',
    '불박이장'
  ];

  // 시설 목록
  final List<String> facilities = [
    '엘리베이터', '주차장', 'CCTV', '복층',
    '옥탑'
  ];

  final List<String> conditions = ['2인 거주 가능', '여성 전용', '반려동물 가능'];

  // 선택된 항목들
  final List<String> selectedOptions = [];
  final List<String> selectedFacilities = [];
  final List<String> selectedConditions = [];

  void _validateInputs() {
    setState(() {
      // 모든 에러 초기화
      areaError = null;
      floorError = null;
      optionsError = null;
      facilitiesError = null;
      conditionsError = null;

      bool isValid = true;

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

      // 옵션 검증
      if (selectedOptions.isEmpty) {
        optionsError = '옵션을 선택해 주세요';
        isValid = false;
      }

      // 시설 검증
      if (selectedFacilities.isEmpty) {
        facilitiesError = '시설을 선택해 주세요';
        isValid = false;
      }

      // 조건 검증
      if (selectedConditions.isEmpty) {
        conditionsError = '조건을 선택해 주세요';
        isValid = false;
      }

      // 모든 검증 통과
      if (isValid) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddRoomHandoverScreen7(),
          ),
        );
      }
    });
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
                        items: options,
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
                        items: facilities,
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
                        items: conditions,
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

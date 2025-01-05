import 'package:flutter/material.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen4.dart';
import 'package:livingalone/home/component/custom_double_button.dart';

class AddTicketHandoverScreen3 extends StatefulWidget {
  const AddTicketHandoverScreen3({super.key});

  @override
  State<AddTicketHandoverScreen3> createState() => _AddTicketHandoverScreen3State();
}

class _AddTicketHandoverScreen3State extends State<AddTicketHandoverScreen3> {
  final List<String> buildingTypes = ['횟수 제한','시간 제한', '기간 제한'];
  final List<String> selectedTypes = [];  // 여러 선택을 저장하기 위한 리스트
  bool showError = false;

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else if (selectedTypes.length < 2) {
        selectedTypes.add(type);
      }
      showError = false;
    });
  }

  void _handleNextPress() {
    if (selectedTypes.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTicketHandoverScreen4(types: selectedTypes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용권 양도하기',
      showCloseButton: true,
      currentStep: 3,
      totalSteps: 4,
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Text(
                    '이용권의 조건을 선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                  4.verticalSpace,
                  Text(
                    '최대 2개까지 선택 가능해요',
                    style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                  ),
                  20.verticalSpace,
                  CustomSelectList(
                    // TODO: 수정해야함.
                    items: BuildingType.values.map((e) => e.label).toList(),
                    selected: selectedTypes,  // List<String> 타입
                    onItemSelected: _handleTypeSelection,
                    showError: showError,
                    errorText: '이용권 종류를 선택해 주세요.',
                    multiSelect: true,
                    maxSelect: 2,  // 최대 2개까지 선택 가능
                  ),
                ],
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: _handleNextPress,
          ),
        ],
      ),
    );
  }
}
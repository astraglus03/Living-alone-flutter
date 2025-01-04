import 'package:flutter/material.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_room_handover_screen3.dart';
import 'package:livingalone/home/component/custom_double_button.dart';

class AddRoomHandoverScreen2 extends StatefulWidget {
  const AddRoomHandoverScreen2({super.key});

  @override
  State<AddRoomHandoverScreen2> createState() => _AddRoomHandoverScreen2State();
}

class _AddRoomHandoverScreen2State extends State<AddRoomHandoverScreen2> {
  final List<String> buildingTypes = ['아파트', '빌라', '주택', '오피스텔'];
  String? selectedType;
  bool showError = false;

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedType == type) {
        selectedType = null;
      } else {
        selectedType = type;
      }
      showError = false;
    });
  }

  void _handleNextPress() {
    if (selectedType == null) {
      setState(() {
        showError = true;
      });
    } else {
      // TODO: 다음 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AddRoomHandoverScreen3(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      currentStep: 2,
      totalSteps: 8,
      child: Column(
        children: [
          Expanded(
            child: Container(
              // width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Text(
                    '건물 유형을 선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                  20.verticalSpace,
                  CustomSelectList(
                    items: buildingTypes,
                    selected: selectedType,
                    onItemSelected: _handleTypeSelection,
                    showError: showError,
                    errorText: '건물 유형을 선택해 주세요.',
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

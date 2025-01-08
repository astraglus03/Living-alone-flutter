import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_room_handover_screen3.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverRoomScreen2 extends ConsumerStatefulWidget {
  final String selectedType;
  const EditHandoverRoomScreen2({
    required this.selectedType,
    super.key
});

  @override
  ConsumerState<EditHandoverRoomScreen2> createState() => _AddRoomHandoverScreen2State();
}

class _AddRoomHandoverScreen2State extends ConsumerState<EditHandoverRoomScreen2> {
  String? currentType;
  bool showError = false;

  @override
  void initState() {
    // TODO: implement initState
    currentType = widget.selectedType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시글 수정하기',
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
                    items: BuildingType.values.map((e) => e.label).toList(),
                    selected: currentType,
                    onItemSelected: _handleTypeSelection,
                    showError: showError,
                    errorText: '건물 유형을 선택해 주세요.',
                    multiSelect: false,
                  ),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            appbarBorder: true,
            backgroundColor: BLUE400_COLOR ,
            foregroundColor: WHITE100_COLOR,
            text: '저장',
            textStyle: AppTextStyles.title,
            onTap: _handleFinishPress,
          ),
        ],
      ),
    );
  }

  void _handleTypeSelection(String type) {
    setState(() {
      if (currentType == type) {
        currentType = null;
      } else {
        currentType = type;
      }
      showError = false;
    });
  }

  void _handleFinishPress() {
    if (currentType == null) {
      setState(() {
        showError = true;
      });
    } else {
      // TODO: 다음 이전 화면으로 돌아가 적용하기
      Navigator.of(context).pop();
      ref.read(editRoomPostProvider.notifier).updateBuildingType(currentType!);
    }
  }
}

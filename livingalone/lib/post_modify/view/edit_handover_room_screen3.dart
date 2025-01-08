import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/add_room_handover_screen4.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverRoomScreen3 extends ConsumerStatefulWidget {
  final String selectedType;
  const EditHandoverRoomScreen3 ({
    required this.selectedType,
    super.key
  });

  @override
  ConsumerState<EditHandoverRoomScreen3> createState() => _AddRoomHandoverScreen3State();
}

class _AddRoomHandoverScreen3State extends ConsumerState<EditHandoverRoomScreen3> {

  @override
  void initState() {
    // TODO: implement initState
    currentType = widget.selectedType;
    super.initState();
  }

  String? currentType;
  bool showError = false;

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

  void _handleNextPress() {
    if (currentType == null) {
      setState(() {
        showError = true;
      });
    } else {
      Navigator.of(context).pop();
      ref.read(editRoomPostProvider.notifier).updatePropertyType(currentType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시물 수정하기',
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
                    '매물의 종류를 선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                  40.verticalSpace,
                  CustomSelectList(
                    items: PropertyType.values.map((e) => e.label).toList() ,
                    selected: currentType,
                    onItemSelected: _handleTypeSelection,
                    showError: showError,
                    errorText: '매물의 종류를 선택해 주세요.',
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
            onTap: _handleNextPress,
          ),
        ],
      ),
    );
  }
}

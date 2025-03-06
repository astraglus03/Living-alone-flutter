import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/add_room_handover_screen5.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen5.dart';
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverRoomScreen4 extends ConsumerStatefulWidget {
  final String selectedType;
  const EditHandoverRoomScreen4 ({
    required this.selectedType,
    super.key
});

  @override
  ConsumerState<EditHandoverRoomScreen4> createState() => _AddRoomHandoverScreen4State();
}

class _AddRoomHandoverScreen4State extends ConsumerState<EditHandoverRoomScreen4> {
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
      // TODO: 다음 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EditHandoverRoomScreen5(rentType: currentType!,isEditingPriceOnly: false,),
            settings: RouteSettings(name: "PriceConditionPage")
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시글 수정하기',
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
                    '임대 방식을 선택해 주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                  40.verticalSpace,
                  CustomSelectList(
                    items: RentType.values.map((e) => e.label).toList(),
                    selected: currentType,
                    onItemSelected: _handleTypeSelection,
                    showError: showError,
                    errorText: '임대 방식을 선택해 주세요.',
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

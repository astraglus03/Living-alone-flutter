import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/custom_select_list.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/enum/ticket_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen5.dart';
import 'package:livingalone/handover/view_models/ticket_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/post_modify/view/edit_handover_ticket_screen4.dart';
import 'package:livingalone/post_modify/view_models/edit_ticket_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverTicketScreen3 extends ConsumerStatefulWidget {
  const EditHandoverTicketScreen3({super.key});

  @override
  ConsumerState<EditHandoverTicketScreen3> createState() => _AddTicketHandoverScreen3State();
}

class _AddTicketHandoverScreen3State extends ConsumerState<EditHandoverTicketScreen3> {
  late List<String> selectedLimits = [];  // 여러 선택을 저장하기 위한 리스트
  bool showError = false;


  @override
  void initState() {
    // TODO: implement initState
    final state = ref.read(editTicketPostProvider);

    if(state.remainingNum !=null){
      selectedLimits.add('횟수 제한');
    }
    if(state.remainingTime !=null){
      selectedLimits.add('시간 제한');
    }
    if(state.availableDate !=null){
      selectedLimits.add('기간 제한');
    }
    super.initState();
  }

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedLimits.contains(type)) {
        selectedLimits.remove(type);
      } else if (selectedLimits.length < 2) {
        selectedLimits.add(type);
      }
      showError = false;
    });
  }

  void _handleNextPress() {
    if (selectedLimits.isEmpty) {
      setState(() {
        showError = true;
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditHandoverTicketScreen4(types: selectedLimits),
      ),
    );
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
                    items: LimitType.values.map((e) => e.label).toList(),
                    selected: selectedLimits,  // List<String> 타입
                    onItemSelected: (String label) {
                      _handleTypeSelection(label);
                    },
                    showError: showError,
                    errorText: '이용권 종류를 선택해 주세요.',
                    multiSelect: true,
                    maxSelect: 2,  // 최대 2개까지 선택 가능
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
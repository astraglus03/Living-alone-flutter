import 'package:flutter/material.dart';
import 'package:livingalone/common/component/custom_select_grid.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/ticket_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen4.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen5.dart';
import 'package:livingalone/handover/view_models/ticket_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/post_modify/view_models/edit_ticket_provider.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverTicketScreen2 extends ConsumerStatefulWidget {
  const EditHandoverTicketScreen2({
    super.key
});

  @override
  ConsumerState<EditHandoverTicketScreen2> createState() => _EditHandoverTicketScreen2State();
}

class _EditHandoverTicketScreen2State extends ConsumerState<EditHandoverTicketScreen2> {
  final _formKey = GlobalKey<FormState>();
  String? selectedItem;
  final _feeController = TextEditingController();
  bool? hasTransferFee;
  bool showFeeError = false;
  bool showTypeError = false;
  bool showFeeAmountError = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(editTicketPostProvider);

    selectedItem = state.ticketType;
    hasTransferFee = state.maintenanceFee !=0 ? true : false ;

    if(hasTransferFee !=null){
      _feeController.text = state.maintenanceFee.toString();
    } else{
      _feeController.text='';
    }

    _feeController.addListener(() {
      if (_feeController.text.isNotEmpty && showFeeAmountError) {
        setState(() {
          showFeeAmountError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _feeController.dispose();
    super.dispose();
  }

  void _toggleTransferFee(bool value) {
    setState(() {
      if (hasTransferFee == value) {
        hasTransferFee = null;
      } else {
        hasTransferFee = value;
      }
      if (showFeeError) showFeeError = false;
    });
  }

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedItem == type) {
        selectedItem = null;
      } else {
        selectedItem = type;
      }
      showTypeError = false;
    });
  }

  void _validateForm() {
    setState(() {
      showTypeError = selectedItem == null;
      showFeeError = hasTransferFee == null;
      showFeeAmountError = hasTransferFee == true && _feeController.text.trim().isEmpty;
    });

    if (!showTypeError &&
        !showFeeError &&
        !(hasTransferFee == true && showFeeAmountError) &&
        _formKey.currentState!.validate()) {
      final fee = hasTransferFee == true ? _feeController.text.trim().toString() : '0';

      ref.read(editTicketPostProvider.notifier).updateTicketTypeInfo(
        selectedItem!,
        int.tryParse(fee),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시글 수정하기',
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: 24).r,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text(
                          '이용권의 정보를 입력해 주세요',
                          style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                        ),
                        20.verticalSpace,
                        CustomSingleSelectGrid(
                          label: '이용권 유형',
                          items: TicketType.values.map((e) => e.label).toList(),
                          selectedItem: selectedItem,
                          onItemSelected: _handleTypeSelection,
                        ),
                        if(showTypeError)
                          Padding(
                            padding: EdgeInsets.only(
                                top: 4.0
                            ).w,
                            child: ShowErrorText(errorText: '이용권 유형을 입력해 주세요'),
                          ),
                        28.verticalSpace,
                        Divider(color: GRAY200_COLOR),
                        28.verticalSpace,
                        Text(
                          '양도 수수료 여부',
                          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            _buildFeeOption('있음', true),
                            9.horizontalSpace,
                            _buildFeeOption('없음', false),
                          ],
                        ),
                        if (showFeeError)
                          Padding(
                            padding: EdgeInsets.only(
                                top: 4.0
                            ).w,
                            child: ShowErrorText(errorText: '양도 수수료 여부를 선택해 주세요'),
                          ),
                        if (hasTransferFee == true) ...[
                          28.verticalSpace,
                          Divider(color: GRAY200_COLOR,),
                          28.verticalSpace,
                          Text(
                            '수수료',
                            style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                          ),
                          10.verticalSpace,
                          Container(
                            width: 345.w,
                            decoration: BoxDecoration(
                              color: GRAY100_COLOR,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextFormField(
                              controller: _feeController,
                              keyboardType: TextInputType.number,
                              style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                              decoration: InputDecoration(
                                hintText: '0',
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: Text(
                                    '만원',
                                    style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                hintStyle: AppTextStyles.title.copyWith(color: GRAY400_COLOR),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                              ),
                            ),
                          ),
                          if (showFeeAmountError)
                            Padding(
                              padding: EdgeInsets.only(top: 4.0).w,
                              child: ShowErrorText(errorText: '수수료 금액을 입력해 주세요'),
                            ),
                        ],
                        100.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomBottomButton(
            appbarBorder: true,
            backgroundColor: BLUE400_COLOR ,
            foregroundColor: WHITE100_COLOR,
            text: '저장',
            textStyle: AppTextStyles.title,
            onTap: _validateForm,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeOption(String text, bool value) {
    return GestureDetector(
      onTap: () => _toggleTransferFee(value),
      child: Container(
        width: 168.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: hasTransferFee == value ? BLUE100_COLOR : GRAY100_COLOR,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasTransferFee == value ? BLUE400_COLOR : GRAY200_COLOR,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.body1.copyWith(
              color: GRAY800_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
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
import 'package:livingalone/user/component/component_button2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTicketHandoverScreen3 extends ConsumerStatefulWidget {
  const AddTicketHandoverScreen3({super.key});

  @override
  ConsumerState<AddTicketHandoverScreen3> createState() => _AddTicketHandoverScreen3State();
}

class _AddTicketHandoverScreen3State extends ConsumerState<AddTicketHandoverScreen3> {
  final _formKey = GlobalKey<FormState>();
  final _feeController = TextEditingController();
  final priceController = TextEditingController();
  bool? hasTransferFee;
  bool showFeeError = false;
  bool showTypeError = false;
  bool showFeeAmountError = false;

  @override
  void initState() {
    super.initState();
    
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
    priceController.dispose();
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

  void _validateForm() {
    if(priceController.text.trim().isEmpty){
      showFeeError = true;
      return;
    }

    setState(() {

      showFeeError = hasTransferFee == null;
      showFeeAmountError = hasTransferFee == true && _feeController.text.trim().isEmpty;
    });

    if (!showTypeError && 
        !showFeeError && 
        !(hasTransferFee == true && showFeeAmountError) && 
        _formKey.currentState!.validate()) {
      final price = _feeController.text.isEmpty ? 0 : _feeController.text.trim();
      ref.read(ticketHandoverProvider.notifier).update(
        price: int.tryParse(price.toString()),
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AddTicketHandoverScreen4()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용권 양도하기',
      showCloseButton: true,
      currentStep: 3,
      totalSteps: 5,
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
                          '양도비를 입력해 주세요',
                          style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                        ),
                        28.verticalSpace,
                        CustomPriceField(
                          width: 345.w,
                          label: '이용권 가격',
                          units: '만원',
                          texFieldBackgroundColor: GRAY100_COLOR,
                          controller: priceController,
                        ),
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
                            child: ShowErrorText(errorText: '이용권 가격을 입력해주세요'),
                          ),
                        if (hasTransferFee == true) ...[
                          28.verticalSpace,
                          Divider(color: GRAY200_COLOR,),
                          28.verticalSpace,
                          CustomPriceField(
                            width: 345.w,
                            label: '수수료',
                            units: '만원',
                            texFieldBackgroundColor: GRAY100_COLOR,
                            controller: _feeController,
                            // focusNode: areaFocus,
                            // onChanged: (_) {
                            //   if (areaError != null) {
                            //     setState(() {
                            //       areaError = null;
                            //     });
                            //   }
                            // },
                            // onSubmitted: () => FocusScope.of(context).requestFocus(totalFloorFocus),
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
          CustomDoubleButton(
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
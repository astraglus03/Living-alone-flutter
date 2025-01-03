import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/user/component/component_button2.dart';

class AddTicketHandoverScreen3 extends StatefulWidget {
  @override
  _AddTicketHandoverScreen3State createState() =>
      _AddTicketHandoverScreen3State();
}

class _AddTicketHandoverScreen3State extends State<AddTicketHandoverScreen3> {
  final _formKey = GlobalKey<FormState>();
  final typeController = TextEditingController();
  final _feeController = TextEditingController();
  bool? hasTransferFee;
  bool showError = false;

  @override
  void dispose() {
    typeController.dispose();
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
      showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용권 양도하기',
      showCloseButton: true,
      currentStep: 2,
      totalSteps: 3,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                padding: EdgeInsets
                    .symmetric(horizontal: 24)
                    .r,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        '이용권의 정보를 입력해 주세요',
                        style: AppTextStyles.heading2.copyWith(
                            color: GRAY800_COLOR),
                      ),
                      20.verticalSpace,
                      Text(
                        '이용권 유형',
                        style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      ComponentButton2(
                        controller: typeController,
                        hintText: '예) 헬스장, 헬스PT, 필라테스, 독서실 등',
                        type: TextInputType.text,
                        onPressed: typeController.clear,
                        backgroundColor: GRAY100_COLOR,
                      ),
                      28.verticalSpace,
                      Divider(color: GRAY200_COLOR),
                      28.verticalSpace,
                      Text(
                        '양도 수수료 여부',
                        style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      Row(
                        children: [
                          _buildFeeOption('있음', true),
                          9.horizontalSpace,
                          _buildFeeOption('없음', false),
                        ],
                      ),
                      if (showError)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            '양도 수수료 여부를 선택해 주세요',
                            style: AppTextStyles.caption2.copyWith(
                                color: Colors.red),
                          ),
                        ),
                      if (hasTransferFee == true) ...[
                        28.verticalSpace,
                        Divider(color: GRAY200_COLOR,),
                        28.verticalSpace,
                        CustomPriceField(label: '수수료', controller:_feeController,texFieldBackgroundColor: GRAY100_COLOR,width: 345.w,),
                      ],
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              if (hasTransferFee == null) {
                setState(() {
                  showError = true;
                });
                return;
              }
              if (_formKey.currentState!.validate()) {
                // Handle the next action
              }
            },
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

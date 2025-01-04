import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen3.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen4.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTicketHandoverScreen2 extends StatefulWidget {
  @override
  _AddTicketHandoverScreen2State createState() => _AddTicketHandoverScreen2State();
}

class _AddTicketHandoverScreen2State extends State<AddTicketHandoverScreen2> {
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
      totalSteps: 4,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                      Text(
                        '이용권 유형',
                        style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
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
                      if (showError)
                        Column(
                          children: [
                            8.verticalSpace,
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/image/warning.svg',
                                ),
                                4.horizontalSpace,
                                Text(
                                  '양도 수수료 여부를 선택해 주세요',
                                  style: AppTextStyles.caption2.copyWith(color: ERROR_TEXT_COLOR),
                                ),
                              ],
                            ),
                          ],
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
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AddTicketHandoverScreen3()));
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
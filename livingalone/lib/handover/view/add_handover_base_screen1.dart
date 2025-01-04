import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/component/post_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class AddHandoverBaseScreen1 extends StatefulWidget {
  final PostType type;
  final Widget nextScreen;

  const AddHandoverBaseScreen1({
    required this.type,
    required this.nextScreen,
    super.key,
  });

  @override
  State<AddHandoverBaseScreen1> createState() => _AddHandoverBaseScreen1State();
}

class _AddHandoverBaseScreen1State extends State<AddHandoverBaseScreen1> {
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final detailAddressController = TextEditingController();
  final addressFocus = FocusNode();
  final detailAddressFocus = FocusNode();
  String? addressError;
  String? detailAddressError;

  Future<void> _openAddressSearch() async {
    KopoModel? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    if (model != null) {
      setState(() {
        addressController.text = '${model.address} ${model.buildingName}'.trim();
      });
    }
  }

  String get _title {
    switch (widget.type) {
      case PostType.room:
        return '자취방 양도하기';
      case PostType.ticket:
        return '이용권 양도하기';
    }
  }

  String get _subtitle {
    switch (widget.type) {
      case PostType.room:
        return '양도할 방의 주소를 정확하게 확인해 주세요.';
      case PostType.ticket:
        return '양도할 이용권의 시설 주소를 정확하게 확인해 주세요.';
    }
  }

  int get _totalSteps {
    switch (widget.type) {
      case PostType.room:
        return 8;
      case PostType.ticket:
        return 4;
    }
  }

  void _validateAddress() {
    setState(() {
      if (addressController.text.trim().isEmpty) {
        addressError = '주소를 입력해주세요';
      } else {
        addressError = null;
      }
    });
  }

  void _validateDetailAddress(String? value) {
    setState(() {
      if (value == null || value.trim().isEmpty) {
        detailAddressError = '상세주소를 입력해주세요';
      } else if (value.length > 30) {
        detailAddressError = '상세주소는 30자 이내로 입력해주세요';
      } else {
        detailAddressError = null;
      }
    });
  }

  bool _isFormValid() {
    _validateAddress();
    _validateDetailAddress(detailAddressController.text);
    return addressError == null && detailAddressError == null;
  }

  @override
  void dispose() {
    addressController.dispose();
    detailAddressController.dispose();
    addressFocus.dispose();
    detailAddressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: _title,
      showCloseButton: true,
      currentStep: 1,
      totalSteps: _totalSteps,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text('주소를 입력해 주세요',
                          style: AppTextStyles.heading1.copyWith(color: GRAY800_COLOR),
                        ),
                        4.verticalSpace,
                        Text(_subtitle,
                          style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                        ),
                        40.verticalSpace,
                        Text('주소',
                          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                        ),
                        10.verticalSpace,
                        Container(
                          width: 345.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: GRAY100_COLOR,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: GRAY200_COLOR),
                          ),
                          child: TextFormField(
                            controller: addressController,
                            readOnly: true,
                            onTap: () {
                              _openAddressSearch();
                              _validateAddress();
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: IconButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  onPressed: _openAddressSearch,
                                  icon: Icon(
                                    Icons.search,
                                    color: GRAY600_COLOR,
                                    size: 24,
                                  ),
                                ),
                              ),
                              hintText: '예) 상명대길 31, 안서동 300',
                              hintStyle: AppTextStyles.subtitle.copyWith(
                                color: GRAY400_COLOR,
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            ),
                          ),
                        ),
                        if (addressError != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: ShowErrorText(errorText: addressError!),
                          ),
                        24.verticalSpace,
                        Row(
                          children: [
                            Text(
                              '상세주소',
                              style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                            ),
                            8.horizontalSpace,
                            Text('동, 호수는 본인만 확인할 수 있어요.',style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),)
                          ],
                        ),
                        10.verticalSpace,
                        _buildDetailAddressField(),
                        if (detailAddressError != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: ShowErrorText(errorText: detailAddressError!),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              if (_isFormValid()) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => widget.nextScreen),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailAddressField() {
    return Container(
      width: 345.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: GRAY100_COLOR,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: GRAY200_COLOR),
      ),
      child: TextFormField(
        controller: detailAddressController,
        focusNode: detailAddressFocus,
        onChanged: (value) {
          _validateDetailAddress(value);
        },
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: detailAddressController.clear,
            icon: SvgPicture.asset('assets/image/signupDelete.svg',fit: BoxFit.cover,),
          ),
          hintText: '동, 호수를 입력해 주세요',
          hintStyle: AppTextStyles.subtitle.copyWith(
            color: GRAY400_COLOR,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
} 
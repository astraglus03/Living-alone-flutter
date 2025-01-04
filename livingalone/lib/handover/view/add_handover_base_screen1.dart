import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
      child: Stack(
        children: [
          GestureDetector(
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
                          onTap: _openAddressSearch,
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
                      24.verticalSpace,
                      Text(
                        '상세주소',
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
                          controller: detailAddressController,
                          focusNode: detailAddressFocus,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
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
} 
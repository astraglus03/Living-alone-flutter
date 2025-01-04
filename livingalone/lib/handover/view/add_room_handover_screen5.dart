import 'package:flutter/material.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
import 'package:livingalone/handover/view/add_room_handover_screen6.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRoomHandoverScreen5 extends StatefulWidget {
  final String rentType;  // '전세', '월세', '단기임대' 중 하나

  const AddRoomHandoverScreen5({
    required this.rentType,
    super.key,
  });

  @override
  State<AddRoomHandoverScreen5> createState() => _AddRoomHandoverScreen5State();
}

class _AddRoomHandoverScreen5State extends State<AddRoomHandoverScreen5> {
  final depositController = TextEditingController();
  final monthlyRentController = TextEditingController();
  final maintenanceController = TextEditingController();
  final depositFocus = FocusNode();
  final monthlyRentFocus = FocusNode();
  final maintenanceFocus = FocusNode();
  String? errorMessage;

  void _validateInputs() {
      switch (widget.rentType) {
        case '전세':
          if (depositController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '보증금을 입력해주세요';
            });
            return;
          }
          if (maintenanceController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '관리비를 입력해주세요';
            });
            return;
          }
          break;

        case '월세':
          if (depositController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '보증금을 입력해주세요';
            });
            return;
          }
          if (monthlyRentController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '월세를 입력해주세요';
            });
            return;
          }
          if (maintenanceController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '관리비를 입력해주세요';
            });
            return;
          }
          break;

        case '단기양도':
          if (monthlyRentController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '월세를 입력해주세요';
            });
            return;
          }
          if (maintenanceController.text.trim().isEmpty) {
            setState(() {
              errorMessage = '관리비를 입력해주세요';
            });
            return;
          }
          break;
      }

      // 모든 검증 통과
      errorMessage = null;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AddRoomHandoverScreen6(),
        ),
      );
  }

  @override
  void dispose() {
    depositController.dispose();
    monthlyRentController.dispose();
    maintenanceController.dispose();
    depositFocus.dispose();
    monthlyRentFocus.dispose();
    maintenanceFocus.dispose();
    super.dispose();
  }

  List<Widget> _buildPriceFields() {
    switch (widget.rentType) {
      case '전세':
        return [
          CustomPriceField(
            label: '보증금',
            controller: depositController,
            focusNode: depositFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            onSubmitted: () => FocusScope.of(context).requestFocus(maintenanceFocus),
          ),
          16.verticalSpace,
          CustomPriceField(
            label: '관리비',
            controller: maintenanceController,
            focusNode: maintenanceFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
          ),
        ];
      
      case '월세':
        return [
          CustomPriceField(
            label: '보증금',
            controller: depositController,
            focusNode: depositFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            onSubmitted: () => FocusScope.of(context).requestFocus(monthlyRentFocus),
          ),
          16.verticalSpace,
          CustomPriceField(
            label: '월세',
            controller: monthlyRentController,
            focusNode: monthlyRentFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            onSubmitted: () => FocusScope.of(context).requestFocus(maintenanceFocus),
          ),
          16.verticalSpace,
          CustomPriceField(
            label: '관리비',
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            controller: maintenanceController,
            focusNode: maintenanceFocus,
          ),
        ];
      
      case '단기양도':
        return [
          CustomPriceField(
            label: '월세',
            controller: monthlyRentController,
            focusNode: monthlyRentFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            onSubmitted: () => FocusScope.of(context).requestFocus(maintenanceFocus),
          ),
          16.verticalSpace,
          CustomPriceField(
            label: '관리비',
            controller: maintenanceController,
            focusNode: maintenanceFocus,
            onChanged: (_) {
              if (errorMessage != null) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
          ),
        ];
      
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      currentStep: 5,
      totalSteps: 8,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(bottom: 50.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      '가격 조건을 입력해 주세요',
                      style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                    ),
                    4.verticalSpace,
                    Text('선택한 임대 방식의 가격 조건을 확인해 주세요.',
                      style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                    ),
                    20.verticalSpace,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16).r,
                      decoration: BoxDecoration(
                        color: GRAY100_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(10)).r,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.rentType,
                            style: AppTextStyles.title.copyWith(color: BLUE400_COLOR),
                          ),
                          16.verticalSpace,
                          ..._buildPriceFields(),
                        ],
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: ShowErrorText(errorText: errorMessage!),
                      ),
                  ],
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: _validateInputs,
          ),
        ],
      ),
    );
  }
}

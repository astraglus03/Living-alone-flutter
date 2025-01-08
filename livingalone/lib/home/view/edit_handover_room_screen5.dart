import 'package:flutter/material.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/common/component/custom_price_field.dart';
import 'package:livingalone/handover/view/add_room_handover_screen6.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/view_models/edit_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';

class EditHandoverRoomScreen5 extends ConsumerStatefulWidget {
  final String rentType;  // '전세', '월세', '단기양도' 중 하나
  final String? deposit;
  final String? monthlyRent;
  final String? maintenanceFee;
  final bool isEditingPriceOnly;

  const EditHandoverRoomScreen5({
    required this.rentType,
    required this.isEditingPriceOnly,
    this.deposit,
    this.monthlyRent,
    this.maintenanceFee,
    super.key,
  });

  @override
  ConsumerState<EditHandoverRoomScreen5> createState() => _AddRoomHandoverScreen5State();
}

class _AddRoomHandoverScreen5State extends ConsumerState<EditHandoverRoomScreen5> {

  late final TextEditingController depositController;
  late final TextEditingController monthlyRentController;
  late final TextEditingController maintenanceController;
  final depositFocus = FocusNode();
  final monthlyRentFocus = FocusNode();
  final maintenanceFocus = FocusNode();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final previousRentType = ref.read(editPostProvider).rentType;

    // 임대 방식이 변경되었으면 필드를 초기화, 아니면 기존 값 유지
    if (previousRentType != widget.rentType) {
      depositController = TextEditingController();
      monthlyRentController = TextEditingController();
      maintenanceController = TextEditingController();
    } else {
      depositController = TextEditingController(text: widget.deposit ?? '');
      monthlyRentController = TextEditingController(text: widget.monthlyRent ?? '');
      maintenanceController = TextEditingController(text: widget.maintenanceFee ?? '');
    }
  }

  void _validateInputs() {
    final requiredFields = {
      '전세': {'deposit': depositController, 'maintenance': maintenanceController},
      '월세': {
        'deposit': depositController,
        'monthlyRent': monthlyRentController,
        'maintenance': maintenanceController
      },
      '단기양도': {'monthlyRent': monthlyRentController, 'maintenance': maintenanceController},
    }[widget.rentType]!;

    final errorMessages = {
      'deposit': '보증금을 입력해주세요',
      'monthlyRent': '월세를 입력해주세요',
      'maintenance': '관리비를 입력해주세요',
    };

    // 필수 필드 검증
    for (final entry in requiredFields.entries) {
      if (entry.value.text.trim().isEmpty) {
        setState(() {
          errorMessage = errorMessages[entry.key];
        });
        return;
      }
    }

    // 모든 검증 통과
    errorMessage = null;

    // Provider에 데이터 저장
    ref.read(editPostProvider.notifier).updateRentType(widget.rentType);
    ref.read(editPostProvider.notifier).updatePriceInfo(
      deposit: int.tryParse(depositController.text),
      monthlyRent: int.tryParse(monthlyRentController.text),
      maintenanceFee: int.tryParse(maintenanceController.text),
    );
    print(depositController.text);
    print(monthlyRentController.text);
    print(maintenanceController.text);

    if (widget.isEditingPriceOnly) {
      // 가격 조건만 수정하는 경우, 바로 이전 페이지(수정 페이지)로 pop
      Navigator.of(context).pop();
    } else {
      // 임대 방식 -> 가격 조건 -> 수정 페이지 경로라면,
      // 이전 페이지(임대 방식)까지 pop하고 수정 페이지로 돌아가기
      Navigator.of(context).popUntil((route) => route.settings.name == "EditPage");
    }
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
      title: '게시글 수정하기',
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
          CustomBottomButton(
            appbarBorder: true,
            backgroundColor: BLUE400_COLOR ,
            foregroundColor: WHITE100_COLOR,
            text: '저장',
            textStyle: AppTextStyles.title,
            onTap: _validateInputs,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:livingalone/common/component/custom_select_grid.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/ticket_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen3.dart';
import 'package:livingalone/handover/view_models/ticket_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTicketHandoverScreen2 extends ConsumerStatefulWidget {
  const AddTicketHandoverScreen2({super.key});

  @override
  ConsumerState<AddTicketHandoverScreen2> createState() =>
      _AddTicketHandoverScreen2State();
}

class _AddTicketHandoverScreen2State
    extends ConsumerState<AddTicketHandoverScreen2> {
  final _formKey = GlobalKey<FormState>();
  String? selectedItem;
  final typeController = TextEditingController();
  bool showTypeError = false;
  bool showEtcError = false;

  @override
  void dispose() {
    typeController.dispose();
    super.dispose();
  }

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedItem == type) {
        selectedItem = null;
      } else {
        selectedItem = type;
        showEtcError = false;
      }
      showTypeError = false;
    });
  }

  void _validateForm() {
    setState(() {
      showTypeError = selectedItem == null;
    });

    if (selectedItem == '기타' && typeController.text.trim().isEmpty) {
      setState(() {
        showEtcError = true;
      });
      return;
    } else {
      setState(() {
        showEtcError = false;
      });
    }

    if (!showTypeError && !showEtcError && _formKey.currentState!.validate()) {
      String ticketType;
      if (selectedItem == '기타') {
        ticketType = typeController.text.trim();
      } else {
        ticketType = selectedItem!;
      }

      ref.read(ticketHandoverProvider.notifier).update(
        ticketType: ticketType,
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddTicketHandoverScreen3()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용권 양도하기',
      showCloseButton: true,
      currentStep: 2,
      totalSteps: 5,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                          style: AppTextStyles.heading2
                              .copyWith(color: GRAY800_COLOR),
                        ),
                        20.verticalSpace,
                        CustomSingleSelectGrid(
                          label: '이용권 유형',
                          items: TicketType.values.map((e) => e.label).toList(),
                          selectedItem: selectedItem,
                          onItemSelected: _handleTypeSelection,
                        ),
                        if (showTypeError)
                          Padding(
                            padding: EdgeInsets.only(top: 4.0).w,
                            child: ShowErrorText(errorText: '이용권 유형을 입력해 주세요'),
                          ),
                        28.verticalSpace,
                        Divider(color: GRAY200_COLOR),
                        28.verticalSpace,
                        if(selectedItem == '기타')
                        ComponentButton(
                          controller: typeController,
                          hintText: '이용권 유형을 입력해 주세요',
                          type: TextInputType.text,
                          formFieldBackground: GRAY100_COLOR,
                          onPressed: () {
                            typeController.clear();
                          },
                        ),
                        if (showEtcError)
                          Padding(
                            padding: EdgeInsets.only(top: 4.0).w,
                            child: ShowErrorText(errorText: '기타 이용권 유형을 입력해 주세요'),
                          ),
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
}

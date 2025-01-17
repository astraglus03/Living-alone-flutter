import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/ticket_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen6.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/handover/view_models/ticket_handover_provider.dart';

class AddTicketHandoverScreen5 extends ConsumerStatefulWidget {
  final Set<LimitType> types;

  const AddTicketHandoverScreen5({
    required this.types,
    super.key,
  });

  @override
  ConsumerState<AddTicketHandoverScreen5> createState() => _AddTicketHandoverScreen5State();
}

class _AddTicketHandoverScreen5State extends ConsumerState<AddTicketHandoverScreen5> {
  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime(2024, 1, 1);
  final _lastDay = DateTime(2049, 12, 31);
  Map<String, String?> _errorMessages = {};

  void _validateInputs(){
    bool hasError = false;

    for (LimitType type in widget.types) {
      if (type == LimitType.periodLimit) {
        if (_selectedDay == null) {
          setState(() {
            _errorMessages[type.label] = '이용권 만료일을 선택해 주세요';
            hasError = true;
          });
        }
      } else if (type == LimitType.numberLimit) {
        if (_countController.text.isEmpty) {
          setState(() {
            _errorMessages[type.label] = '남은 횟수를 입력해 주세요';
            hasError = true;
          });
        }
      } else if (type == LimitType.timeLimit) {
        if (_timeController.text.isEmpty) {
          setState(() {
            _errorMessages[type.label] = '남은 시간을 입력해 주세요';
            hasError = true;
          });
        }
      }
    }

    if (!hasError) {
      ref.read(ticketHandoverProvider.notifier).update(
        remainingCount: widget.types.contains(LimitType.numberLimit) 
            ? int.parse(_countController.text) 
            : null,
        remainingHours: widget.types.contains(LimitType.timeLimit) 
            ? int.parse(_timeController.text) 
            : null,
        expiryDate: widget.types.contains(LimitType.periodLimit) 
            ? _selectedDay 
            : null,
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (_)=> const AddTicketHandoverScreen6()),
      );
    }
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이용권 만료일',
          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
        ),
        10.verticalSpace,
        TableCalendar(
          locale: 'ko_KR',
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          pageJumpingEnabled: false,
          calendarStyle: CalendarStyle(
            defaultTextStyle:
            AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            weekendTextStyle:
            AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            outsideTextStyle:
            AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
            selectedTextStyle:
            AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
            todayTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            todayDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            rangeHighlightColor: BLUE100_COLOR,
            cellMargin: EdgeInsets.zero,
            cellPadding: EdgeInsets.zero,
          ),
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, _) {
              return Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BLUE400_COLOR,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style:
                      AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                    ),
                  ),
                ),
              );
            },
          ),
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
            headerPadding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 8.h),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: BLUE400_COLOR,
              size: 24.w,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: BLUE400_COLOR,
              size: 24.w,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: AppTextStyles.body1.copyWith(
              color: GRAY400_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            weekendStyle: AppTextStyles.body1.copyWith(
              color: GRAY400_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          daysOfWeekHeight: 48,
          rowHeight: 48,
        ),
        if (_errorMessages['기간 제한'] != null)
          Column(
            children: [
              8.verticalSpace,
              Row(
                children: [
                  SvgPicture.asset('assets/image/warning.svg'),
                  4.horizontalSpace,
                  Text(
                    _errorMessages['기간 제한']!,
                    style: AppTextStyles.caption2.copyWith(color: ERROR_TEXT_COLOR),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRemainingField(LimitType type) {
    final controller = type == LimitType.numberLimit ? _countController : _timeController;
    final suffix = type == LimitType.numberLimit ? '회' : '시간';
    final label = type == LimitType.numberLimit ? '남은 횟수' : '남은 시간';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
            decoration: InputDecoration(
              hintText: '0',
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Text(
                  suffix,
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
        if (_errorMessages[type.label] != null)
          Column(
            children: [
              8.verticalSpace,
              Row(
                children: [
                  SvgPicture.asset('assets/image/warning.svg'),
                  4.horizontalSpace,
                  Text(
                    _errorMessages[type.label]!,
                    style: AppTextStyles.caption2.copyWith(color: ERROR_TEXT_COLOR),
                  ),
                ],
              ),
            ],
          ),
        28.verticalSpace,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '이용권 양도하기',
      showCloseButton: true,
      currentStep: 4,
      totalSteps: 5,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        Text(
                          '이용권의 조건을 입력해 주세요',
                          style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                        ),
                        14.verticalSpace,
                        ...List.generate(widget.types.length, (index) {
                          final type = widget.types.elementAt(index);
                          return Column(
                            children: [
                              if (type == LimitType.periodLimit)
                                _buildCalendar()
                              else
                                _buildRemainingField(type),
                              if (index < widget.types.length - 1) ...[
                                Divider(color: GRAY200_COLOR),
                                14.verticalSpace,
                              ],
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
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
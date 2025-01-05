import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view/add_ticket_handover_screen5.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTicketHandoverScreen4 extends StatefulWidget {
  final List<String> types; // 선택된 조건들의 리스트

  const AddTicketHandoverScreen4({
    required this.types,
    super.key,
  });

  @override
  State<AddTicketHandoverScreen4> createState() => _AddTicketHandoverScreen4State();
}

class _AddTicketHandoverScreen4State extends State<AddTicketHandoverScreen4> {
  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime(2024, 1, 1);
  final _lastDay = DateTime(2049, 12, 31);
  Map<String, String?> _errorMessages = {};

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
              _errorMessages['기간 제한'] = null;
            });
          },
          calendarStyle: CalendarStyle(
            defaultTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            weekendTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            outsideTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
            selectedTextStyle: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
            selectedDecoration: BoxDecoration(
              color: BLUE400_COLOR,
              shape: BoxShape.circle,
            ),
            todayTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            todayDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            rangeHighlightColor: BLUE100_COLOR,
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
            weekdayStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
            weekendStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          ),
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

  Widget _buildRemainingField(String type) {
    final controller = type == '횟수 제한' ? _countController : _timeController;
    final suffix = type == '횟수 제한' ? '회' : '시간';
    final label = type == '횟수 제한' ? '남은 횟수' : '남은 시간';

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
        if (_errorMessages[type] != null)
          Column(
            children: [
              8.verticalSpace,
              Row(
                children: [
                  SvgPicture.asset('assets/image/warning.svg'),
                  4.horizontalSpace,
                  Text(
                    _errorMessages[type]!,
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
      currentStep: 3,
      totalSteps: 4,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
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
                          final type = widget.types[index];
                          return Column(
                            children: [
                              if (type == '기간 제한')
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
            onTap: () {
              bool hasError = false;

              for (String type in widget.types) {
                if (type == '기간 제한') {
                  if (_selectedDay == null) {
                    setState(() {
                      _errorMessages[type] = '이용권 만료일을 선택해 주세요';
                      hasError = true;
                    });
                  }
                } else if (type == '횟수 제한') {
                  if (_countController.text.isEmpty) {
                    setState(() {
                      _errorMessages[type] = '남은 횟수를 입력해 주세요';
                      hasError = true;
                    });
                  }
                } else if (type == '시간 제한') {
                  if (_timeController.text.isEmpty) {
                    setState(() {
                      _errorMessages[type] = '남은 시간을 입력해 주세요';
                      hasError = true;
                    });
                  }
                }
              }

              if (!hasError) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AddTicketHandoverScreen5()));
              }
            },
          ),
        ],
      ),
    );
  }
}
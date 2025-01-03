import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:table_calendar/table_calendar.dart';

class AddRoomHandoverScreen7 extends StatefulWidget {
  final String rentType;  // '전세', '월세', '단기임대'

  const AddRoomHandoverScreen7({
    required this.rentType,
    super.key,
  });

  @override
  State<AddRoomHandoverScreen7> createState() => _AddRoomHandoverScreen7State();
}

class _AddRoomHandoverScreen7State extends State<AddRoomHandoverScreen7> {
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime focusedDay = DateTime.now();
  bool isChecked = false;

  final DateTime kFirstDay = DateTime(2024, 1, 1);
  final DateTime kLastDay = DateTime(2040, 12, 31);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
      rangeStart = null;
      rangeEnd = null;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      selectedDay = null;
      rangeStart = start;
      rangeEnd = end;
      this.focusedDay = focusedDay;
    });
  }

  void _togglePossibleImmediately() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 보고 있는 달이 첫 달인지 마지막 달인지 확인
    bool isFirstMonth = focusedDay.year == kFirstDay.year && focusedDay.month == kFirstDay.month;
    bool isLastMonth = focusedDay.year == kLastDay.year && focusedDay.month == kLastDay.month;

    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      currentStep: 7,
      totalSteps: 8,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                Text(
                  widget.rentType ==' 단기임대' ?
                  '단기임대 기간을 선택해 주세요' : '입주 가능일을 선택해 주세요.',
                  style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                ),
                4.verticalSpace,
                Text(
                  widget.rentType == '단기임대' 
                    ? '입주 가능 날짜와 즉시 입주 여부를 확인해 주세요.'
                    : '입주일과 퇴거일을 선택하고, 즉시 입주 여부를 확인해 주세요',
                  style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                ),
                20.verticalSpace,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: isFirstMonth 
                              ? null  // 첫 달이면 null로 버튼 비활성화
                              : () {
                                  setState(() {
                                    focusedDay = DateTime(
                                      focusedDay.year,
                                      focusedDay.month - 1,
                                    );
                                  });
                                },
                          icon: Icon(
                            Icons.chevron_left,
                            color: isFirstMonth 
                                ? GRAY400_COLOR  // 비활성화 시 회색으로
                                : BLUE400_COLOR,
                          ),
                        ),
                        Text(
                          '${focusedDay.year}년 ${focusedDay.month}월',
                          style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                        ),
                        IconButton(
                          onPressed: isLastMonth
                              ? null  // 마지막 달이면 null로 버튼 비활성화
                              : () {
                                  setState(() {
                                    focusedDay = DateTime(
                                      focusedDay.year,
                                      focusedDay.month + 1,
                                    );
                                  });
                                },
                          icon: Icon(
                            Icons.chevron_right,
                            color: isLastMonth
                                ? GRAY400_COLOR  // 비활성화 시 회색으로
                                : BLUE400_COLOR,
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    TableCalendar(
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: focusedDay,
                      selectedDayPredicate: widget.rentType != '단기임대'
                          ? (day) => isSameDay(selectedDay, day)
                          : null,
                      rangeStartDay: rangeStart,
                      rangeEndDay: rangeEnd,
                      calendarFormat: CalendarFormat.month,
                      rangeSelectionMode: widget.rentType == '단기임대'
                          ? RangeSelectionMode.enforced
                          : RangeSelectionMode.disabled,
                      onDaySelected: widget.rentType != '단기임대'
                          ? _onDaySelected
                          : null,
                      onRangeSelected: widget.rentType == '단기임대'
                          ? _onRangeSelected
                          : null,
                      onPageChanged: (focusedDay) {
                        setState(() {
                          this.focusedDay = focusedDay;
                        });
                      },
                      headerVisible: false,
                      locale: 'ko_KR',
                      enabledDayPredicate: (day) => true,
                      calendarStyle: CalendarStyle(
                        todayDecoration: const BoxDecoration(),
                        todayTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        selectedDecoration: BoxDecoration(
                          color: BLUE400_COLOR,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                        rangeStartDecoration: BoxDecoration(
                          color: BLUE400_COLOR,
                          shape: BoxShape.circle,
                        ),
                        rangeEndDecoration: BoxDecoration(
                          color: BLUE400_COLOR,
                          shape: BoxShape.circle,
                        ),
                        rangeStartTextStyle: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                        rangeEndTextStyle: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                        withinRangeTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        rangeHighlightColor: BLUE100_COLOR,
                        defaultTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        weekendTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
                        outsideTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
                        outsideDaysVisible: true,
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
                        weekendStyle: AppTextStyles.body1.copyWith(color: GRAY400_COLOR),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                GestureDetector(
                  onTap: _togglePossibleImmediately,
                  child: Container(
                    width: 345.w,
                    height: 56.h,
                    padding: REdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      isChecked ? BLUE100_COLOR : GRAY100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(12)).w,
                      border: Border.all(
                        color: isChecked
                            ? BLUE400_COLOR
                            : GRAY200_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomAgreeButton(
                          isActive: isChecked,
                          activeColor: BLUE400_COLOR,
                          inactiveColor: GRAY400_COLOR,
                        ),
                        12.horizontalSpace,
                        Text(
                          '즉시 입주 가능',
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              // TODO: 다음 화면으로 이동
            },
          ),
        ],
      ),
    );
  }
}

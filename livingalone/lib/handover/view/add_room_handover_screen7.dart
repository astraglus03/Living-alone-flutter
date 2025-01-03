import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/add_room_handover_screen8.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddRoomHandoverScreen7 extends ConsumerStatefulWidget {
  static String get routeName => 'addRoomHandover8';

  const AddRoomHandoverScreen7({super.key});

  @override
  ConsumerState<AddRoomHandoverScreen7> createState() =>
      _AddRoomHandoverScreen9State();
}

class _AddRoomHandoverScreen9State
    extends ConsumerState<AddRoomHandoverScreen7> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime(2024, 1, 1);
  final _lastDay = DateTime(2049, 12, 31);
  String? _errorMessage;

  Widget _buildCalendar() {
    return TableCalendar(
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
      calendarStyle: CalendarStyle(
        defaultTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        weekendTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        outsideTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
        selectedTextStyle:
        AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      currentStep: 7,
      totalSteps: 8,
      showCloseButton: true,
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
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      '입주가능일을 선택해주세요',
                      style:
                      AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                    ),
                    20.verticalSpace,
                    _buildCalendar(),
                    if (_selectedDay == null)
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/image/warning.svg',
                              ),
                              4.horizontalSpace,
                              Text('입주 가능일을 선택해 주세요',
                                  style: AppTextStyles.caption2
                                      .copyWith(color: ERROR_TEXT_COLOR)),
                            ],
                          ),
                          10.verticalSpace,
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              if (_selectedDay == null) {
                setState(() {
                  _errorMessage = '입주가능일을 선택해주세요';
                });
                return;
              }
              // TODO: 다음 화면으로 이동
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AddRoomHandoverScreen8()));
            },
          ),
        ],
      ),
    );
  }
}
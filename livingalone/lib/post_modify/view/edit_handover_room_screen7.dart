import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/component/agree_container.dart';
import 'package:livingalone/handover/view/add_room_handover_screen8.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditHandoverRoomScreen7 extends ConsumerStatefulWidget {

  const EditHandoverRoomScreen7({
    super.key,
  });

  @override
  ConsumerState<EditHandoverRoomScreen7> createState() =>
      _AddRoomHandoverScreen9State();
}

class _AddRoomHandoverScreen9State
    extends ConsumerState<EditHandoverRoomScreen7> {

  @override
  void initState() {
    // TODO: implement initState
    final state = ref.read(editRoomPostProvider);

    // 시작 날짜 설정
    _currentDay = state.getStartDate();

    if (_currentDay != null) {
      _focusedDay = _currentDay!;
    }

    // 단기 양도인 경우 종료 날짜도 설정
    if (state.rentType == RentType.shortRent.label) {
      rentType = state.rentType;
      _rangeStart = state.getStartDate();
      _rangeEnd = state.getEndDate();
      if (_rangeStart != null) {
        _focusedDay = _rangeStart!;
      }
    }

    isAgreedSelected = state.immediateEnter!;
  }

  String? rentType;
  DateTime? _currentDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime(2024, 1, 1);
  final _lastDay = DateTime(2049, 12, 31);
  String? _errorMessage;
  bool isAgreedSelected = false;

  void _validateAndNavigate() {
    if (!isAgreedSelected) {
      if (rentType == RentType.shortRent.label) {
        if (_rangeStart == null || _rangeEnd == null) {
          setState(() {
            _errorMessage = '입주기간을 선택해주세요';
          });
          return;
        }
      } else {
        if (_currentDay == null) {
          setState(() {
            _errorMessage = '입주가능일을 선택해주세요';
          });
          return;
        }
      }
    }
    
    ref.read(editRoomPostProvider.notifier).updateDate(
      startDate:_rangeStart ?? _currentDay,
      endDate: rentType == RentType.shortRent.label ? _rangeEnd : null,
      immediateIn: isAgreedSelected,
    );

    Navigator.of(context).pop();
  }

  void _toggleFirstAgreed() {
    setState(() {
      isAgreedSelected = !isAgreedSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '게시물 수정하기',
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Text(
                    rentType == RentType.shortRent.label
                        ? '단기양도 기간을 선택해 주세요'
                        : '입주가능일을 선택해주세요',
                    style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                  ),
                  4.verticalSpace,
                  Text(
                    rentType == RentType.shortRent.label
                        ? '입주일, 퇴거일과 즉시 입주 여부를 확인해 주세요.'
                        : '입주 가능 날짜와 즉시 입주 여부를 확인해 주세요.',
                    style:
                    AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                  ),
                  20.verticalSpace,
                  _buildCalendar(),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: ShowErrorText(errorText: _errorMessage!),
                    ),
                  28.verticalSpace,
                  AgreeContainer(
                    text: '즉시 입주 가능',
                    isSelected: isAgreedSelected,
                    onTap: _toggleFirstAgreed,
                  ),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            appbarBorder: true,
            backgroundColor: BLUE400_COLOR ,
            foregroundColor: WHITE100_COLOR,
            text: '저장',
            textStyle: AppTextStyles.title,
            onTap: _validateAndNavigate,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    if (rentType == RentType.shortRent.label) {
      return TableCalendar(
        locale: 'ko_KR',
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: RangeSelectionMode.enforced,
        onRangeSelected: (start, end, focusedDay) {
          setState(() {
            _rangeStart = start;
            _rangeEnd = end;
            _focusedDay = focusedDay;
          });
        },
        pageJumpingEnabled: false,
        calendarStyle: CalendarStyle(
          defaultTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          weekendTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          outsideTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY400_COLOR),
          selectedTextStyle: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
          todayTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          todayDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          cellMargin: EdgeInsets.zero,
          cellPadding: EdgeInsets.zero,
          withinRangeTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
          rangeHighlightScale: 0.8,
          rangeHighlightColor: BLUE100_COLOR,
          outsideDaysVisible: true,
        ),
        calendarBuilders: CalendarBuilders(
          rangeStartBuilder: (context, date, _) {
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
                    style: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                  ),
                ),
              ),
            );
          },
          rangeEndBuilder: (context, date, _) {
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
                    style: AppTextStyles.subtitle.copyWith(color: WHITE100_COLOR),
                  ),
                ),
              ),
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return Center(
              child: Text(
                '${day.day}',
                style: AppTextStyles.subtitle.copyWith(color: GRAY200_COLOR),
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
      );
    } else {
      return TableCalendar(
        locale: 'ko_KR',
        firstDay: _firstDay,
        lastDay: _lastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_currentDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _currentDay = selectedDay;
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
      );
    }
  }
}

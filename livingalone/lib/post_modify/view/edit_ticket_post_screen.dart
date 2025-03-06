import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen2.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen3.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen4.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen5.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen6.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen7.dart';
import 'package:livingalone/home/view/home_screen.dart';
import 'package:livingalone/post_modify/view/edit_handover_room_screen8.dart';
import 'package:livingalone/post_modify/view/edit_handover_ticket_screen2.dart';
import 'package:livingalone/post_modify/view/edit_handover_ticket_screen3.dart';
import 'package:livingalone/post_modify/view/edit_handover_ticket_screen4.dart';
import 'package:livingalone/post_modify/view/edit_handover_ticket_screen5.dart';
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/post_modify/view_models/edit_ticket_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditTicketPostScreen extends ConsumerStatefulWidget {
  const EditTicketPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditTicketPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditTicketPostScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editTicketPostProvider);
    return DefaultLayout(
      title: '게시물 수정하기',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  20.verticalSpace,
                  Container(
                    width: 345.w,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14).w,
                    decoration: BoxDecoration(
                      color: BLUE100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(10)).r
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/image/ticket_mini.svg',width: 24, height: 24,),
                        10.horizontalSpace,
                        Expanded(
                          child: Text('${state.address} ${state.detailedAddress}',
                            style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  _buildListTile('이용권 유형', state.ticketType!, () async {
                     await Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditHandoverTicketScreen2(),),
                    );
                  }),
                  _buildListTile('양도 수수료 여부', state.maintenanceFee != 0 ? '${state.maintenanceFee}' :'없음', () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditHandoverTicketScreen2(),),);
                  }),
                  _buildListTile1('이용권 조건', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverTicketScreen3(),settings: RouteSettings(name: "PriceConditionPage"),));
                  }, state),
                  // // TODO: 받아온 모델에서 만약 posttype이 자취방 이라면 안보이게 조건.
                  // _buildListTile2('방 정보', '', (){
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen6(
                  //     state.area!,
                  //     state.currentFloor!,
                  //     state.totalFloor!,
                  //     state.options!,
                  //     state.facilities!,
                  //     state.conditions!,
                  //   )));
                  // }),
                  _buildListTile('사진', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverTicketScreen5()));
                  }),
                  _buildListTile('제목', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverTicketScreen5()));
                  }),
                  _buildListTile('소개 글', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverTicketScreen5()));
                  }),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            appbarBorder: true,
            backgroundColor: BLUE400_COLOR,
            foregroundColor: WHITE100_COLOR,
            text: '수정 완료',
            textStyle: AppTextStyles.title,
            onTap: () {
              // TODO: Patch api 활용하여 넣기.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String value,VoidCallback onTap) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 56,
      ),
      // padding: EdgeInsets.symmetric(horizontal: 24).w,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
        titleTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.body2.copyWith(color: GRAY600_COLOR),
            ),
            6.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: GRAY300_COLOR
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildListTile1(String title, String rentType, VoidCallback onTap, EditTicketPostState state) {
    List<Map<String, String>> priceConditions = [];

    if (state.remainingNum != null && state.remainingTime != null && state.availableDate != null) {
      priceConditions = [
        {'title': '횟수', 'value': '${state.remainingNum}회'},
        {'title': '시간', 'value': '${state.remainingTime}시간'},
        {'title': '기간', 'value': '${state.availableDate}'},
      ];
    } else if (state.remainingNum != null && state.remainingTime != null) {
      priceConditions = [
        {'title': '횟수', 'value': '${state.remainingNum}회'},
        {'title': '기간', 'value': '${state.remainingTime}시간'},
      ];
    } else if (state.remainingTime != null && state.availableDate != null) {
      priceConditions = [
        {'title': '시간', 'value': '${state.remainingTime}시간'},
        {'title': '기간', 'value': '${state.availableDate}'},
      ];
    } else if (state.remainingNum != null && state.availableDate != null) {
      priceConditions = [
        {'title': '횟수', 'value': '${state.remainingNum}회'},
        {'title': '기간', 'value': '${state.availableDate}'},
      ];
    } else if (state.remainingNum != null) {
      priceConditions = [
        {'title': '횟수', 'value': '${state.remainingNum}회'},
      ];
    } else if (state.remainingTime != null) {
      priceConditions = [
        {'title': '시간', 'value': '${state.remainingTime}시간'},
      ];
    } else if (state.availableDate != null) {
      priceConditions = [
        {'title': '기간', 'value': '${state.availableDate}'},
      ];
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: 56,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
        titleTextStyle: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.verticalSpace,
            ...priceConditions.map((item) => _buildRoomInfoItem(item['title']!, item['value']!)).toList(),
            4.verticalSpace,
          ],
        ),
        subtitleTextStyle: AppTextStyles.body2.copyWith(color: GRAY600_COLOR),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: GRAY300_COLOR
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildRoomInfoItem(String title, String value) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52.w,
              child: Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: AppTextStyles.body2.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
          ],
        ),
        4.verticalSpace,
      ],
    );
  }
}

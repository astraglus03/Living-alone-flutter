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
import 'package:livingalone/post_modify/view_models/edit_room_provider.dart';
import 'package:livingalone/user/component/custom_bottom_button.dart';
import 'package:livingalone/user/view/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editRoomPostProvider);
    return DefaultLayout(
      title: '게시물 수정하기',
      showCloseButton: true,
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
                        SvgPicture.asset('assets/image/homemini.svg',width: 24, height: 24,),
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
                  _buildListTile('건물 유형', state.buildingType!, () async {
                     await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditHandoverRoomScreen2(
                          selectedType: state.buildingType!,  // 현재 선택된 값 전달
                        ),
                      ),
                    );
                  }),
                  _buildListTile('매물 종류', state.propertyType!, () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen3(selectedType: state.propertyType!)));
                  }),
                  _buildListTile('임대 방식', state.rentType!, () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen4(selectedType: state.rentType!)));
                  }),
                  _buildListTile1('가격 조건', state.rentType!, (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen5(
                      rentType: state.rentType!,
                      deposit: state.deposit.toString(),
                      monthlyRent: state.monthlyRent.toString(),
                      maintenanceFee: state.maintenanceFee.toString(),
                      isEditingPriceOnly: true,
                    ),settings: RouteSettings(name: "PriceConditionPage"),));
                  }),
                  // TODO: 받아온 모델에서 만약 posttype이 자취방 이라면 안보이게 조건.
                  _buildListTile2('방 정보', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen6(
                      state.area!,
                      state.currentFloor!,
                      state.totalFloor!,
                      state.options!,
                      state.facilities!,
                      state.conditions!,
                    )));
                  }),
                  _buildListTile('입주 가능일', '${state.availableDate!.toString()} ${state.immediateEnter == true ? '\n(즉시 입주 가능)': ''}', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen7()));
                  }),
                  _buildListTile('사진', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen8()));
                  }),
                  _buildListTile('제목', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen8()));
                  }),
                  _buildListTile('소개 글', '', (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> EditHandoverRoomScreen8()));
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

  Widget _buildListTile1(String title, String rentType, VoidCallback onTap) {
    final state = ref.watch(editRoomPostProvider);
    List<Map<String, String>> priceConditions = [];
    if (rentType == '월세') {
      priceConditions = [
        {'title': '보증금', 'value': '${state.deposit}만원'},
        {'title': '월세', 'value': '${state.monthlyRent}만원'},
        {'title': '관리비', 'value': '${state.maintenanceFee}만원'},
      ];
    } else if (rentType == '전세') {
      priceConditions = [
        {'title': '보증금', 'value': '500만원'},
        {'title': '관리비', 'value': '5만원'},
      ];
    } else if (rentType == '단기양도') {
      priceConditions = [
        {'title': '월세', 'value': '${state.monthlyRent}만원'},
        {'title': '관리비', 'value': '${state.maintenanceFee}만원'},
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

  Widget _buildListTile2(String title, String rentType, VoidCallback onTap) {
    final state = ref.watch(editRoomPostProvider);
    List<Map<String, String>> roomInfo = [
      {'title': '면적', 'value': '${state.area}'},
      {'title': '층', 'value': '${state.currentFloor} / ${state.totalFloor} 층'},
      {'title': '옵션', 'value': state.options!.isNotEmpty ? state.options!.join(', ') : '없음'},
      {'title': '시설', 'value': state.facilities!.isNotEmpty ? state.facilities!.join(', ') : '없음'},
      {'title': '조건', 'value': state.conditions!.isNotEmpty ? state.conditions!.join(', ') : '없음'},
    ];

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
            ...roomInfo.map((item) => _buildRoomInfoItem(item['title']!, item['value']!)).toList(),
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

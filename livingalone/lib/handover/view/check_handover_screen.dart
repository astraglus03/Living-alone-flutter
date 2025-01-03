import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/add_room_handover_screen1.dart';
import 'package:livingalone/home/component/custom_bottom_button2.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckHandOverScreen extends StatefulWidget {
  static String get routeName => 'terms';

  const CheckHandOverScreen({super.key});

  @override
  State<CheckHandOverScreen> createState() => _CheckHandOverScreenState();
}

class _CheckHandOverScreenState extends State<CheckHandOverScreen> {
  bool firstAgreedSelected = false;
  bool secondAgreedSelected = false;

  void _toggleFirstAgreed() {
    setState(() {
      firstAgreedSelected = !firstAgreedSelected;
    });
  }

  void _toggleSecondAgreed() {
    setState(() {
      secondAgreedSelected = !secondAgreedSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      child: Stack(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.fromLTRB(24, 20, 0, 0).r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '양도 전 확인하세요!',
                  style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),
                ),
                4.verticalSpace,
                Text(
                  '안전한 양도를 위해 아래 사항을 확인 후 진행해 주세요.',
                  style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),
                ),
                20.verticalSpace,
                GestureDetector(
                  onTap: _toggleFirstAgreed,
                  child: Container(
                    width: 345.w,
                    height: 56.h,
                    padding: REdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          firstAgreedSelected ? BLUE100_COLOR : GRAY100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(12)).w,
                      border: Border.all(
                        color: firstAgreedSelected
                            ? BLUE400_COLOR
                            : GRAY200_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomAgreeButton(
                          isActive: firstAgreedSelected,
                          activeColor: BLUE400_COLOR,
                          inactiveColor: GRAY400_COLOR,
                        ),
                        12.horizontalSpace,
                        Text(
                          '집주인의 동의를 받았나요?',
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: _toggleSecondAgreed,
                  child: Container(
                    width: 345.w,
                    height: 56.h,
                    padding: REdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          secondAgreedSelected ? BLUE100_COLOR : GRAY100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(12)).w,
                      border: Border.all(
                        color: secondAgreedSelected
                            ? BLUE400_COLOR
                            : GRAY200_COLOR,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomAgreeButton(
                            isActive: secondAgreedSelected,
                            activeColor: BLUE400_COLOR,
                            inactiveColor: GRAY400_COLOR,
                        ),
                        12.horizontalSpace,
                        Text(
                          '계약서의 내용을 정확히 검토했나요?',
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                330.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("• ",
                          style: AppTextStyles.caption2
                              .copyWith(color: GRAY500_COLOR)),
                    ),
                    Expanded(
                      child: Text(
                        "방 양도 전 반드시 집주인의 동의를 받아야 합니다. 집주인의 사전 동의\n없이 임의로 양도하거나 이중계약을 체결하는 것은 관련 법률에 위반될\n수 있습니다.",
                        style: AppTextStyles.caption2
                            .copyWith(color: GRAY500_COLOR),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("• ",
                          style: AppTextStyles.caption2
                              .copyWith(color: GRAY500_COLOR)),
                    ),
                    Expanded(
                      child: Text(
                        '"모양"은 사용자 간의 거래를 중개하는 플랫폼이며, 계약 과정에서 발생\n하는 법적 책임은 사용자 본인에게 있습니다.',
                        style: AppTextStyles.caption2
                            .copyWith(color: GRAY500_COLOR),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomBottomButton2(
            backgroundColor: BLUE400_COLOR,
            foregroundColor: WHITE100_COLOR,
            disabledBackgroundColor: GRAY200_COLOR,
            disabledForegroundColor: GRAY800_COLOR,
            text: '다음',
            textStyle: AppTextStyles.title,
            isEnabled: secondAgreedSelected && firstAgreedSelected,
            onTap: () {
              // TODO: 나중에 go router 적용할 것. 임시로 넣어둠.
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddRoomHandoverScreen1()));
            },
          ),
        ],
      ),
    );
  }
}

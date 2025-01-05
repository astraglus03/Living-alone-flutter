import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/component/agree_container.dart';
import 'package:livingalone/home/component/custom_bottom_button2.dart';
import 'package:livingalone/user/component/custom_agree_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckHandoverBaseScreen extends StatefulWidget {
  final PostType type;
  final Widget nextScreen;

  const CheckHandoverBaseScreen({
    required this.type,
    required this.nextScreen,
    super.key,
  });

  @override
  State<CheckHandoverBaseScreen> createState() => _CheckHandoverBaseScreenState();
}

class _CheckHandoverBaseScreenState extends State<CheckHandoverBaseScreen> {
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

  List<String> get _agreeTexts {
    switch (widget.type) {
      case PostType.room:
        return [
          '집주인의 동의를 받았나요?',
          '계약서의 내용을 정확히 검토했나요?',
        ];
      case PostType.ticket:
        return [
          '각 시설의 양도 허용 여부를 확인하였나요?',
          '양도 수수료가 발생하는지 확인하였나요?',
        ];
    }
  }

  String get _title {
    switch (widget.type) {
      case PostType.room:
        return '자취방 양도하기';
      case PostType.ticket:
        return '이용권 양도하기';
    }
  }

  String get _warningText {
    switch (widget.type) {
      case PostType.room:
        return "방 양도 전 반드시 집주인의 동의를 받아야 합니다. 집주인의 사전 동의\n없이 임의로 양도하거나 이중계약을 체결하는 것은 관련 법률에 위반될\n수 있습니다.";
      case PostType.ticket:
        return "이용권 양도 전 반드시 시설 운영자의 동의를 받아야 합니다. 운영자의\n사전 동의 없이 임의로 양도하거나 허위 정보를 제공하는 행위는 관련\n규정에 위반될 수 있습니다.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: _title,
      showCloseButton: true,
      child: Stack(
        children: [
          Container(
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
                AgreeContainer(
                  text: _agreeTexts[0],
                  isSelected: firstAgreedSelected,
                  onTap: _toggleFirstAgreed,
                ),
                10.verticalSpace,
                AgreeContainer(
                  text: _agreeTexts[1],
                  isSelected: secondAgreedSelected,
                  onTap: _toggleSecondAgreed,
                ),
                330.verticalSpace,
                _buildWarningText(_warningText),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("• ",
                          style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR)),
                    ),
                    Expanded(
                      child: Text(
                        '"모양"은 사용자 간의 거래를 중개하는 플랫폼이며, 계약 과정에서 발생\n하는 법적 책임은 사용자 본인에게 있습니다.',
                        style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR),
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => widget.nextScreen),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWarningText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("• ",
              style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR)),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR),
          ),
        ),
      ],
    );
  }
} 
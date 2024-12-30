import 'package:flutter/material.dart';
import 'package:livingalone/common/component/colored_image.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/component/rent_info_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LivingDetailScreen extends StatelessWidget {
  final PageController pController = PageController();
  final ScrollController scrollController = ScrollController();
  final List<String> imageUrls = [
    'assets/image/smu_mascort1.jpg',
    'assets/image/smu_mascort2.jpg',
    'assets/image/smu_mascort3.jpg',
    'assets/image/smu_mascort4.jpg',
    'assets/image/smu_mascort5.jpg',
  ];

  LivingDetailScreen({super.key});

  void scrollToSection(double offset) {
    scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      actions: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 393.h,
                      child: PageView.builder(
                        controller: pController,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            imageUrls[index],
                            width: 393.w,
                            height: 393.h,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: pController,
                          count: imageUrls.length,
                          onDotClicked: (index) {
                            pController.jumpToPage(index);
                          },
                          effect: const SlideEffect(
                            dotWidth: 6,
                            dotHeight: 6,
                            spacing: 4.0,
                            dotColor: WHITE100_COLOR,
                            activeDotColor: BLUE400_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 72.h,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                          .r,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: GRAY200_COLOR,
                    width: 1,
                  ))),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: GRAY200_COLOR,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)).r,
                        ),
                      ),
                      12.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // FIXME: 기본 위젯 크기때문에 위아래 0.5씩 제거
                          3.5.verticalSpace,
                          Text(
                            '서은',
                            style: AppTextStyles.body1
                                .copyWith(color: GRAY800_COLOR),
                          ),
                          4.verticalSpace,
                          Text(
                            '2024.12.10 21:16',
                            style: AppTextStyles.caption2
                                .copyWith(color: GRAY500_COLOR),
                          ),
                          3.5.verticalSpace,
                        ],
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 174.h,
                  padding: EdgeInsets.symmetric(horizontal: 24).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '천안시 동남구 각원사길 59-5',
                        style: AppTextStyles.caption2
                            .copyWith(color: GRAY600_COLOR),
                      ),
                      6.verticalSpace,
                      Text(
                        '안서동보아파트 101동',
                        style:
                            AppTextStyles.title.copyWith(color: GRAY800_COLOR),
                      ),
                      12.verticalSpace,
                      RentInfoCard(
                        leftTitle: '월세',
                        rightTitle: '관리비',
                        leftFee: 41,
                        rightFee: 9,
                        subFeeOrTimes: '만원',
                      ),
                    ],
                  ),
                ),

                12.verticalSpace,
                _tabBar(),
                200.verticalSpace,
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 96.h,
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 34).r,
              decoration: const BoxDecoration(
                  color: WHITE100_COLOR,
                  border: Border(
                      top: BorderSide(
                    width: 1,
                    color: GRAY200_COLOR,
                  ))),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: BLUE100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(8)).r,
                    ),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      icon: SvgPicture.asset('assets/image/like_border.svg'),
                      onPressed: () {
                        //TODO: 즐겨찾기 이벤트 처리
                      },
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: BLUE100_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(8)).r,
                    ),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      icon: ColoredIcon(
                          imagePath: 'assets/image/share.svg', isActive: true),
                      onPressed: () {
                        // TODO: 공유하기 이벤트 처리 필요
                      },
                    ),
                  ),
                  8.horizontalSpace,
                  SizedBox(
                    width: 253.w,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: BLUE400_COLOR,
                          foregroundColor: WHITE100_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)).r,
                          )),
                      onPressed: () {
                        //TODO: 채팅하기 이벤트 처리
                      },
                      child: Text(
                        '채팅하기',
                        style: AppTextStyles.title,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return DefaultTabController(
      animationDuration: Duration(milliseconds: 300),
      length: 4,
      child: Column(
        children: [
          TabBar(
            onTap: (index) {
              switch (index) {
                case 0:
                  scrollToSection(0);
                case 1:
                  scrollToSection(500);
                case 2:
                  scrollToSection(1000);
                case 3:
                  scrollToSection(1500);
              }
            },
            padding: EdgeInsets.symmetric(horizontal: 24).r,
            isScrollable: false,
            labelPadding: EdgeInsets.zero,
            tabs: [
              SizedBox(
                  width: 86,
                  height: 48,
                  child: Tab(
                    text: '매물 소개',
                  )),
              SizedBox(
                  width: 86,
                  height: 48,
                  child: Tab(
                    text: '방 정보',
                  )),
              SizedBox(
                  width: 86,
                  height: 48,
                  child: Tab(
                    text: '위치',
                  )),
              SizedBox(
                  width: 86,
                  height: 48,
                  child: Tab(
                    text: '댓글',
                  )),
            ],
            labelColor: BLUE400_COLOR,
            unselectedLabelColor: GRAY400_COLOR,
            labelStyle: AppTextStyles.subtitle,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: BLUE400_COLOR, width: 2),
            ),
            indicatorColor: BLUE400_COLOR,
            dividerColor: GRAY200_COLOR,
            dividerHeight: 1,
          )
        ],
      ),
    );
  }
}

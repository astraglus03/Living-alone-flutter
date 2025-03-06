import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:livingalone/chat/view/chat_list_screen.dart';
import 'package:livingalone/common/component/colored_image.dart';
import 'package:livingalone/common/component/roottab_colored_image.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/handover/view/check_room_handover_screen.dart';
import 'package:livingalone/handover/view/check_ticket_handover_screen.dart';
import 'package:livingalone/home/view/home_screen.dart';
import 'package:livingalone/map/view/map_screen.dart';
import 'package:livingalone/mypage/view/mypage_screen.dart';
import 'package:livingalone/neighbor/view/neighbor_communication_screen.dart';
import 'package:livingalone/neighbor/view/write_community_post_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'rootTab';

  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  final ValueNotifier<bool> _openCloseDial = ValueNotifier(false);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultLayout(
          child: PersistentTabView(
            tabs: [
              PersistentTabConfig(
                screen: HomeScreen(),
                item: _buildTabItem(
                  imagePath: 'assets/image/home.svg',
                  title: '홈',
                ),
              ),
              PersistentTabConfig(
                screen: const MapScreen(),
                item: _buildTabItem(
                  imagePath: 'assets/image/map.svg',
                  title: '지도',
                ),
              ),
              PersistentTabConfig(
                screen: const NeighborCommunicationScreen(),
                item: _buildTabItem(
                  imagePath: 'assets/image/community_24.svg',
                  title: '커뮤니티',
                ),
              ),
              PersistentTabConfig(
                screen: const ChatListScreen(),
                item: _buildTabItem(
                  imagePath: 'assets/image/chat.svg',
                  title: '채팅',
                ),
              ),
              PersistentTabConfig(
                screen: const MyPageScreen(),
                item: _buildTabItem(
                  imagePath: 'assets/image/my.svg',
                  title: '마이',
                ),
              ),
            ],
            navBarBuilder: (navBarConfig) =>
                Style1BottomNavBar(
                  navBarConfig: navBarConfig,
                ),
            onTabChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        if (_currentIndex == 0)
          ValueListenableBuilder<bool>(
            valueListenable: _openCloseDial,
            builder: (context, isOpen, child) {
              return isOpen
                  ? Positioned.fill(
                      child: GestureDetector(
                        onTap: () => _openCloseDial.value = false,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        if (_currentIndex == 0)
          Positioned(
            right: 10.w,
            bottom: 108.h,
            child: SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: BLUE400_COLOR,
              foregroundColor: Colors.white,
              activeBackgroundColor: BLUE200_COLOR,
              activeForegroundColor: BLUE400_COLOR,
              iconTheme: IconThemeData(
                size: 24.sp,
              ),
              elevation: 0,
              renderOverlay: false,
              animationDuration: Duration(milliseconds: 150),
              closeManually: true,
              spacing: 5,
              spaceBetweenChildren: 1,
              buttonSize: Size(56.w, 56.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)).r
              ),
              openCloseDial: _openCloseDial,
              children: [
                SpeedDialChild(
                  labelWidget: Container(
                    width: 148.w,
                    height: 88.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _openCloseDial.value = false;
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CheckRoomHandoverScreen(),
                                    ),
                                  );
                                });
                              },
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/image/homemini.svg',),
                                      SizedBox(width: 8),
                                      Text(
                                          '자취방 양도하기',
                                          style: AppTextStyles.body2.copyWith(color: GRAY800_COLOR)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              hoverColor: BLUE200_COLOR,
                              splashColor: BLUE200_COLOR,
                              highlightColor: BLUE200_COLOR,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _openCloseDial.value = false;
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CheckTicketHandoverScreen(),
                                    ),
                                  );
                                });
                              },
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/image/ticket_mini.svg',),
                                      SizedBox(width: 8),
                                      Text('이용권 양도하기',
                                        style: AppTextStyles.body2.copyWith(color: GRAY800_COLOR),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              hoverColor: BLUE200_COLOR,
                              splashColor: BLUE200_COLOR,
                              highlightColor: BLUE200_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 0,
                  onTap: () {
                    _openCloseDial.value = false;
                  },
                ),
              ],
            ),
          ),


        if (_currentIndex == 2)
          ValueListenableBuilder<bool>(
            valueListenable: _openCloseDial,
            builder: (context, isOpen, child) {
              return isOpen
                  ? Positioned.fill(
                child: GestureDetector(
                  onTap: () => _openCloseDial.value = false,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              )
                  : const SizedBox();
            },
          ),
        if (_currentIndex == 2)
          Positioned(
            right: 10.w,
            bottom: 108.h,
            child: SpeedDial(
              icon: Icons.add,
              activeIcon: Icons.close,
              backgroundColor: BLUE400_COLOR,
              foregroundColor: Colors.white,
              activeBackgroundColor: BLUE200_COLOR,
              activeForegroundColor: BLUE400_COLOR,
              iconTheme: IconThemeData(
                size: 24.sp,
              ),
              elevation: 0,
              renderOverlay: false,
              animationDuration: Duration(milliseconds: 150),
              closeManually: true,
              spacing: 5,
              spaceBetweenChildren: 1,
              buttonSize: Size(56.w, 56.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)).r
              ),
              openCloseDial: _openCloseDial,
              children: [
                SpeedDialChild(
                  labelWidget: Container(
                    width: 148.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _openCloseDial.value = false;
                          Future.delayed(Duration(milliseconds: 100), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WriteCommunityPostScreen(communityId: '1',),
                              ),
                            );
                          });
                        },
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/image/writemini.svg',),
                                SizedBox(width: 8),
                                Text(
                                    '커뮤니티 글 쓰기',
                                    style: AppTextStyles.body2.copyWith(color: GRAY800_COLOR)
                                ),
                              ],
                            ),
                          ),
                        ),
                        hoverColor: BLUE200_COLOR,
                        splashColor: BLUE200_COLOR,
                        highlightColor: BLUE200_COLOR,
                      ),
                    ),
                  ),
                  elevation: 0,
                  onTap: () {
                    _openCloseDial.value = false;
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _openCloseDial.dispose();
    super.dispose();
  }

  static ItemConfig _buildTabItem({
    required String imagePath,
    required String title,
  }) {
    return ItemConfig(
      activeForegroundColor: GRAY800_COLOR,
      inactiveForegroundColor: GRAY400_COLOR,
      icon: RootTabColoredImage(imagePath: imagePath, isActive: true),
      inactiveIcon: RootTabColoredImage(imagePath: imagePath, isActive: false),
      title: title,
      textStyle: AppTextStyles.body2,
    );
  }
}



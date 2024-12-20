import 'package:flutter/material.dart';
import 'package:livingalone/chat/view/chat_screen.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/home/view/home_screen.dart';
import 'package:livingalone/map/view/map_screen.dart';
import 'package:livingalone/mypage/view/mypage_screen.dart';
import 'package:livingalone/neighbor/view/neighbor_communication_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RootTab extends StatelessWidget {
  static String get routeName => 'RootTab';

  const RootTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
            activeForegroundColor: BLUE400_COLOR,
            inactiveForegroundColor: GRAY400_COLOR,
            icon: Image.asset('assets/image/active_home.png',),
            inactiveIcon:  Image.asset('assets/image/inactive_home.png',),
            title: "홈",
            textStyle: AppTextStyles.body2,
          ),
        ),
        PersistentTabConfig(
          screen: MapScreen(),
          item: ItemConfig(
            activeForegroundColor: BLUE400_COLOR,
            inactiveForegroundColor: GRAY400_COLOR,
            icon: Image.asset('assets/image/map.png',),
            // TODO: 활성화 되었을때 파란색 되는 이미지 서은님이 주면 추가 필요
            inactiveIcon:  Image.asset('assets/image/inactive_home.png',),
            title: "지도",
            textStyle: AppTextStyles.body2,
          ),
        ),
        PersistentTabConfig(
          screen: NeighborCommunicationScreen(),
          item: ItemConfig(
            activeForegroundColor: BLUE400_COLOR,
            inactiveForegroundColor: GRAY400_COLOR,
            icon: Image.asset('assets/image/neighbor.png',),
            // TODO: 활성화 되었을때 파란색 되는 이미지 서은님이 주면 추가 필요
            inactiveIcon:  Image.asset('assets/image/inactive_home.png',),
            title: '이웃소통',
            textStyle: AppTextStyles.body2,
          ),
        ),
        PersistentTabConfig(
          screen: ChatScreen(),
          item: ItemConfig(
            activeForegroundColor: BLUE400_COLOR,
            inactiveForegroundColor: GRAY400_COLOR,
            icon: Image.asset('assets/image/chat.png',),
            // TODO: 활성화 되었을때 파란색 되는 이미지 서은님이 주면 추가 필요
            inactiveIcon:  Image.asset('assets/image/inactive_home.png',),
            title: "채팅",
            textStyle: AppTextStyles.body2,
          ),
        ),
        PersistentTabConfig(
          screen: MyPageScreen(),
          item: ItemConfig(
            activeForegroundColor: BLUE400_COLOR,
            inactiveForegroundColor: GRAY400_COLOR,
            icon: Image.asset('assets/image/my.png',),
            // TODO: 활성화 되었을때 파란색 되는 이미지 서은님이 주면 추가 필요
            inactiveIcon:  Image.asset('assets/image/inactive_home.png',),
            title: "마이",
            textStyle: AppTextStyles.body2,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style1BottomNavBar(
            navBarConfig: navBarConfig,
          ),
    );
  }
}

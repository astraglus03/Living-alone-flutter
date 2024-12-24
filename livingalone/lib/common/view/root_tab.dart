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
  static String get routeName => 'rootTab';

  const RootTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: _buildTabItem(
            imagePath: 'assets/image/inactive_home.png',
            title: '홈',
          ),
        ),
        PersistentTabConfig(
          screen: const MapScreen(),
          item: _buildTabItem(
            imagePath: 'assets/image/map.png',
            title: '지도',
          ),
        ),
        PersistentTabConfig(
          screen: const NeighborCommunicationScreen(),
          item: _buildTabItem(
            imagePath: 'assets/image/neighbor.png',
            title: '이웃소통',
          ),
        ),
        PersistentTabConfig(
          screen: const ChatScreen(),
          item: _buildTabItem(
            imagePath: 'assets/image/chat.png',
            title: '채팅',
          ),
        ),
        PersistentTabConfig(
          screen: const MyPageScreen(),
          item: _buildTabItem(
            imagePath: 'assets/image/my.png',
            title: '마이',
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style1BottomNavBar(
            navBarConfig: navBarConfig,
          ),
    );
  }

  static ItemConfig _buildTabItem({
    required String imagePath,
    required String title,
  }) {
    return ItemConfig(
      activeForegroundColor: BLUE400_COLOR,
      inactiveForegroundColor: GRAY400_COLOR,
      icon: _ColoredIcon(imagePath: imagePath, isActive: true),
      inactiveIcon: _ColoredIcon(imagePath: imagePath, isActive: false),
      title: title,
      textStyle: AppTextStyles.body2,
    );
  }
}

class _ColoredIcon extends StatelessWidget {
  final String imagePath;
  final bool isActive;

  const _ColoredIcon({
    Key? key,
    required this.imagePath,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isActive ? BLUE400_COLOR : GRAY400_COLOR,
        BlendMode.srcIn,
      ),
      child: Image.asset(imagePath),
    );
  }
}
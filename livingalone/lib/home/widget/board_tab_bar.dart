import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../common/const/colors.dart';
import '../../common/const/text_styles.dart';
import '../view_models/board_tab_provider.dart';
class BoardTabBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(boardTabProvider);

    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 24),
          _TabButton(
            label: '자취방',
            isSelected: currentTab == 0,
            onTap: () => ref.read(boardTabProvider.notifier).changeTab(0),
          ),
          SizedBox(width: 8),
          _TabButton(
            label: '이용권',
            isSelected: currentTab == 1,
            onTap: () => ref.read(boardTabProvider.notifier).changeTab(1),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: 50,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.subtitle.copyWith(
                    color: isSelected ? GRAY800_COLOR : GRAY400_COLOR,
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              color: isSelected ? GRAY800_COLOR : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

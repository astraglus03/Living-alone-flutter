import 'package:flutter/material.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';

class WriteCommunityPostScreen extends StatelessWidget {
  const WriteCommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      showCloseButton: true,
      title: '커뮤니티 글 쓰기',
      actions: TextButton(
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        onPressed: () {},
        child: Text(
          '완료',
          style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        ),
      ),
      child: Center(
        child: Text('커뮤니티 글 쓰기 '),
      ),
    );
  }
}

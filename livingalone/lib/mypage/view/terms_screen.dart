import 'package:flutter/material.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/mypage/view/terms_detail_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '약관 및 개인정보 처리',
      child: Column(
        children: [
          _buildListTile('개인정보 수집 · 이용 동의',onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> TermsDetailScreen()));
          }),
          _buildListTile('개인정보 제3자 제공 동의',onTap: (){

          }),
          _buildListTile('서비스 이용약관',onTap: (){

          }),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: GRAY100_COLOR,
            )
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.subtitle.copyWith(
                color: GRAY800_COLOR,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: GRAY400_COLOR,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/component/common_divider.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/view/edit_profile_screen.dart';
import 'package:livingalone/mypage/view/inquiry_list_screen.dart';
import 'package:livingalone/mypage/view/inquiry_screen.dart';
import 'package:livingalone/mypage/view/notice_list_screen.dart';
import 'package:livingalone/mypage/view/terms_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '',
      showBackButton: false,
      appbarBorder: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: GRAY100_COLOR,
                        child: Icon(
                          Icons.person,
                          size: 40.r,
                          color: GRAY400_COLOR,
                        ),
                      ),
                      20.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '서울대 입시생',
                            style: AppTextStyles.subtitle.copyWith(
                              color: GRAY800_COLOR,
                            ),
                          ),
                          Text(
                            '구매 0 | 판매 0',
                            style: AppTextStyles.caption2.copyWith(
                              color: GRAY500_COLOR,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  12.verticalSpace,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: BLUE100_COLOR,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EditProfileScreen()));
                      },
                      child: Text(
                        '프로필 수정',
                        style: AppTextStyles.body1.copyWith(
                          color: GRAY800_COLOR,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            23.verticalSpace,
            // 나의 활동 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                '나의 활동',
                style: AppTextStyles.body1.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
            6.verticalSpace,
            _buildListTile('관심 목록', onTap: () {}),
            _buildListTile('양도 내역', onTap: () {}),
            _buildListTile('이웃소통 활동', onTap: () {}),
            CommonDivider(),
            20.verticalSpace,
            // 설정 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                '설정',
                style: AppTextStyles.body1.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
            6.verticalSpace,
            _buildListTile('계정 관리', onTap: () {}),
            _buildListTile('알림 설정', onTap: () {}),
            _buildListTile('우리집 설정', onTap: () {}),
            _buildListTile('언어 설정', onTap: () {}),
            CommonDivider(),
            20.verticalSpace,
            // 고객지원 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                '고객지원',
                style: AppTextStyles.body1.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
            6.verticalSpace,
            _buildListTile('문의하기', onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => InquiryScreen(),
              //   ),
              // );
              pushScreenWithoutNavBar(context, InquiryScreen());
            }),
            _buildListTile('약관 및 개인정보 처리', onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => TermsScreen()));
              pushScreenWithoutNavBar(context, TermsScreen());
            }),
            CommonDivider(),
            20.verticalSpace,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                '기타',
                style: AppTextStyles.body1.copyWith(
                  color: GRAY600_COLOR,
                ),
              ),
            ),
            6.verticalSpace,
            _buildListTile('공지사항', onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (_)=> NoticeListScreen()));
              pushScreenWithoutNavBar(context, NoticeListScreen());
            }),
            _buildListTile(
              '로그아웃',
              onTap: () async {
                await ConfirmDialog.show(
                  context: context,
                  title: '로그아웃 하시겠어요?',
                  content: '저장된 정보는 유지되며, 다시 로그인하면 이어서 이용할 수 있습니다.',
                  confirmText: '로그아웃',
                );
              },
            ),
            _buildListTile(
                '탈퇴하기',
              onTap: () async {
                await ConfirmDialog.show(
                  context: context,
                  title: '정말 탈퇴하시겠어요?',
                  content: '계정이 삭제되면 작성한 게시글, 댓글 등 모든 데이터가 영구적으로 삭제됩니다.',
                  confirmText: '탈퇴하기'
                );
              },
            ),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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

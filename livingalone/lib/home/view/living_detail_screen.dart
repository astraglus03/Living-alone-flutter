import 'package:flutter/material.dart';
import 'package:livingalone/common/component/colored_image.dart';
import 'package:livingalone/common/component/colored_image_fill.dart';
import 'package:livingalone/common/component/common_divider.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/utils/data_utils.dart';
import 'package:livingalone/home/component/comments_section.dart';
import 'package:livingalone/home/component/facilities_card.dart';
import 'package:livingalone/home/component/info_detail_card.dart';
import 'package:livingalone/home/component/location_info_card.dart';
import 'package:livingalone/home/component/rent_room_card.dart';
import 'package:livingalone/home/component/rent_use_card.dart';
import 'package:livingalone/home/component/room_info_card.dart';
import 'package:livingalone/home/component/stat_item.dart';
import 'package:livingalone/home/component/ticket_info_card.dart';
import 'package:livingalone/home/models/comment_model.dart';
import 'package:livingalone/home/view_models/living_detail_screen_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/home/view_models/comments_provider.dart';
import 'package:livingalone/home/view_models/like_provider.dart';

class LivingDetailScreen extends ConsumerStatefulWidget {
  final PostType postType;
  final String postId;

  const LivingDetailScreen({
    required this.postType,
    required this.postId,
    super.key,
  });

  @override
  ConsumerState<LivingDetailScreen> createState() => _LivingDetailScreenState();
}

class _LivingDetailScreenState extends ConsumerState<LivingDetailScreen> with SingleTickerProviderStateMixin {
  bool showTabBar = false;
  final PageController pController = PageController();
  final ScrollController scrollController = ScrollController();
  late TabController _tabController;
  double tabBarOpacity = 0.0;

  final statsKey = GlobalKey();
  final introRoomKey = GlobalKey();
  final introTicketKey = GlobalKey();
  final infoRoomKey = GlobalKey();
  final infoTicketKey = GlobalKey();
  final locationKey = GlobalKey();
  final commentsKey = GlobalKey();

  final List<String> imageUrls = [
    'assets/image/smu_mascort1.jpg',
    'assets/image/smu_mascort2.jpg',
    'assets/image/smu_mascort3.jpg',
    'assets/image/smu_mascort4.jpg',
    'assets/image/smu_mascort5.jpg',
  ];

  final List<String> sectionTitles = [
    '방 소개',
    '방 정보',
    '위치',
    '댓글',
  ];



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    scrollController.addListener(_onScroll);
    // 초기 댓글 데이터 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 더미데이터
      final initialComments = widget.postType == PostType.room
        ? <CommentModel>[
        CommentModel(
          username: '서은',
          content: '내일은 집을 보고, 18일 수요일에 가능한\n예약 있나요?',
          time: '2024.12.15 16:12',
          replies: [
            CommentModel(
              username: '고얌미123424123',
              content: '네! 체크해보겠습니다',
              time: '2024.12.15 16:15',
              isAuthor: true,
            ),
          ],
        ),
        CommentModel(
          username: '건동',
          content: '주말 쯤 사진 더 보고 싶은데 추가해 주실 수 있나요? 아니면 채팅으로 부탁드립니다.',
          time: '2024.12.15 16:17',
        ),
      ]  // 명시적으로 타입 지정
        : <CommentModel>[
            CommentModel(
              username: '서은',
              content: '내일은 집을 보고, 18일 수요일에 가능한\n예약 있나요?',
              time: '2024.12.15 16:12',
              replies: [
                CommentModel(
                  username: '고얌미',
                  content: '네! 체크해보겠습니다',
                  time: '2024.12.15 16:15',
                  isAuthor: true,
                ),
              ],
            ),
            CommentModel(
              username: '건동',
              content: '주말 쯤 사진 더 보고 싶은데 추가해 주실 수 있나요? 아니면 채팅으로 부탁드립니다.',
              time: '2024.12.15 16:17',
            ),
          ];
      ref.read(LivingDetailScreenProvider.notifier).setComments(initialComments);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;

    ref.read(LivingDetailScreenProvider.notifier).updateTabBarVisibility(scrollController.offset);
    // 스크롤 위치에 따른 현재 섹션 업데이트
    ref.read(LivingDetailScreenProvider.notifier).updateCurrentSection(scrollController, _tabController, widget.postType);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '',
      appbarBorder: false,
      actions:IconButton(
        onPressed: (){},
        icon: Icon(Icons.more_horiz_rounded),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: scrollController,
            child: Column(
              children: [
                _buildImageSlider(),
                _buildUserInfo(),
                24.verticalSpace,
                widget.postType == PostType.room
                    ? _buildRoomContent()
                    : _buildTicketContent(),
                100.verticalSpace,
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(LivingDetailScreenProvider);
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: state.tabBarOpacity,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: WHITE100_COLOR.withOpacity(state.tabBarOpacity),
                      border: Border(
                        bottom: BorderSide(
                          color: GRAY200_COLOR.withOpacity(state.tabBarOpacity),
                          width: 1,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      labelColor: BLUE400_COLOR,
                      unselectedLabelColor: GRAY400_COLOR,
                      indicatorColor: BLUE400_COLOR,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: AppTextStyles.subtitle,
                      tabs: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Tab(text: widget.postType == PostType.room ? '방 소개' : '이용권 소개'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Tab(text: widget.postType == PostType.room ? '방 정보' : '이용권 정보'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Tab(text: '위치'),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Tab(text: '댓글 ${state.totalCommentsCount}'),
                        ),
                      ],
                      onTap: (index) {
                        final title = _getTitleForIndex(index);
                        ref.read(LivingDetailScreenProvider.notifier).scrollToSection(title, scrollController);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Stack(
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
              onDotClicked: (index) => pController.jumpToPage(index),
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
    );
  }

  Widget _buildUserInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12).r,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: GRAY200_COLOR, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: GRAY200_COLOR,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '고얌미',
                style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
              ),
              4.verticalSpace,
              Text(
                '2024.12.10 21:16',
                style: AppTextStyles.caption2.copyWith(color: GRAY500_COLOR),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '천안시 동남구 각원사길 59-5',
                style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
              ),
              6.verticalSpace,
              Text(
                '안서동보아파트 101동',
                style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
              ),
              12.verticalSpace,
              RentRoomCard(
                rentType: RentType.monthlyRent,
                deposit: 500,
                maintenance: 5,
                monthlyRent: 40,
              ),
              16.verticalSpace,
              _buildStats(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.h),  // 상단 여백 추가
          child: InfoDetailCard(
            key: ref.read(LivingDetailScreenProvider).sectionKeys['매물 소개'],
            title: '방 소개',
            introText: '방학 동안 자리를 비우게 되어 단기 임대합니다.\n1월 1일부터 2월 28일까지 두 달간 깨끗하게 사용하실 분을 구합니다.\n궁금한 점이 있으시면 편하게 채팅 주세요!',
          ),
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,
        RoomInfoCard(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['방 정보'],
          buildingType: '아파트',
          propertyType: '단기임대',
          rentType: '월세',
          area: '33.06m²',
          floor: '7층/10층',
          options: ['에어컨', '세탁기', '냉장고', '전자레인지, 붙박이장'],
          facilities: ['엘리베이터', '주차장', 'CCTV', '복층'],
          conditions: ['반려동물 가능',],
          availableDate: DateTime.now(),
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,
        LocationInfoCard(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['위치'],
          address: '천안시 동남구 각원사길 59-5',
        ),
        24.verticalSpace,
        const FacilitiesCard(
          facilities: ['편의점', '마트', '병원', '약국', '대중교통' , '카페'],
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,
        CommentsSection(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['댓글'],
        ),
        100.verticalSpace,
      ],
    );
  }

  Widget _buildTicketContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '천안시 동남구 각원사길 59-5',
                style: AppTextStyles.caption2.copyWith(color: GRAY600_COLOR),
              ),
              6.verticalSpace,
              Text(
                '헬스장 이용권 양도',
                style: AppTextStyles.title.copyWith(color: GRAY800_COLOR),
              ),
              12.verticalSpace,
              // RentUseCard(
              //     useType: rentType,
              //     leftTime: leftTime,
              //     maintenance:
              // ),
              16.verticalSpace,
              _buildStats(),
            ],
          ),
        ),
        24.verticalSpace,
        InfoDetailCard(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['이용권 소개'],
          title: '이용권 소개',
          introText: '방학 동안 본가에 갈 것 같아 남은 미야짐 헬스 PT 7회권 양도합니다.\n 관심 있으신 분은 연락 주세요!',
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,

        TicketInfoCard(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['이용권 정보'],
          ticketType: '헬스장 회원권',
          remainingCount: '7회',
          transferFee: '5,000원',
          availableDate: '2024.01.01 ~ 2024.02.28',
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,
        LocationInfoCard(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['위치'],
          address: '천안시 동남구 각원사길 59-5',
        ),
        24.verticalSpace,
        const FacilitiesCard(
          facilities: ['편의점', '마트', '병원', '약국', '대중교통' , '카페'],
        ),
        24.verticalSpace,
        CommonDivider(),
        24.verticalSpace,
        CommentsSection(
          key: ref.read(LivingDetailScreenProvider).sectionKeys['댓글'],
        ),
        100.verticalSpace,
      ],
    );
  }

  Widget _buildStats() {
    return SizedBox(
      key: statsKey,
      height: 16.h,
      child: Row(
        children: [
          StatItem(label: '관심', value: 23),
          VerticalDivider(
            color: GRAY400_COLOR,
            width: 10,
            endIndent: 4,
            indent: 4,
          ),
          StatItem(label: '댓글', value: 4),
          VerticalDivider(
            color: GRAY400_COLOR,
            width: 10,
            endIndent: 4,
            indent: 4,
          ),
          StatItem(label: '채팅', value: 1),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 96.h,
        padding: EdgeInsets.fromLTRB(10, 12, 10, 34).r,
        decoration: const BoxDecoration(
          color: WHITE100_COLOR,
          border: Border(
            top: BorderSide(width: 1, color: GRAY200_COLOR),
          ),
        ),
        child: Row(
          children: [
            _buildIconButton(
              onPressed: () {
                ref.read(likeProvider.notifier).toggleLike(widget.postId);
              },
            ),
            8.horizontalSpace,
            _buildShareButton(),
            8.horizontalSpace,
            _buildChatButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
  }) {
    return Container(
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
        icon: Consumer(
          builder: (context, ref, child) {
            final likeState = ref.watch(likeProvider);
            final isLiked = likeState.likedPosts[widget.postId] ?? false;
            return ColoredImageFill(isActive: isLiked);
          },
        ),
        onPressed: () {
          ref.read(likeProvider.notifier).toggleLike(widget.postId);
        },
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
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
        icon: ColoredImage(
          imagePath: 'assets/image/share.svg',
          isActive: true,
        ),
        onPressed: () {
          // TODO: 공유하기 이벤트 처리 필요
          DataUtils.sharePost(
            title: '[모양] 자취방 양도 게시물 공유하기',
            price: '41만원',
            location: '천안시 동남구 각원사길 59-5',
          );
        },
      ),
    );
  }

  Widget _buildChatButton() {
    return SizedBox(
      width: 253.w,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: BLUE400_COLOR,
          foregroundColor: WHITE100_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)).r,
          ),
        ),
        onPressed: () {
          //TODO: 채팅하기 이벤트 처리
        },
        child: Text(
          '채팅하기',
          style: AppTextStyles.title,
        ),
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return widget.postType == PostType.room ? '매물 소개' : '이용권 소개';
      case 1:
        return widget.postType == PostType.room ? '방 정보' : '이용권 정보';
      case 2:
        return '위치';
      case 3:
        return '댓글';
      default:
        return '';
    }
  }
}

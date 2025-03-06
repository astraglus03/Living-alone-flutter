import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:livingalone/mypage/repository/inquiry_repository.dart';
import 'package:livingalone/mypage/view/inquiry_list_screen.dart';
import 'package:livingalone/mypage/view_models/inquiry_provider.dart';
import 'package:livingalone/user/component/custom_snackbar.dart';

class OneOnOneInquiryScreen extends ConsumerStatefulWidget {
  const OneOnOneInquiryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OneOnOneInquiryScreen> createState() => _OneOnOneInquiryScreenState();
}

class _OneOnOneInquiryScreenState extends ConsumerState<OneOnOneInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  final _titleKey = GlobalKey();
  final _contentKey = GlobalKey();
  bool isDropdownOpen = false;
  bool isLoading = false;

  final List<String> _categories = [
    '이용 문의',
    '계정 문의',
    '앱 오류',
    '건의 사항',
    '기타',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _scrollController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  // _submitInquiry 메서드 수정
  Future<void> _submitInquiry() async {
    if (_formKey.currentState!.validate() && _categoryController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        await ref.read(inquiryProvider.notifier).createInquiry(
          category: _categoryController.text,
          title: _titleController.text,
          content: _contentController.text,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => InquiryListScreen()),
        );
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: '문의 등록에 실패했습니다.',
          imagePath: 'assets/image/x.svg',
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      CustomSnackBar.show(
        context: context,
        message: '모든 항목을 입력해주세요.',
        imagePath: 'assets/image/x.svg',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '1:1 문의하기',
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  isDropdownOpen = false;
                });
              },
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '문의 유형',
                          style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR,
                          ),
                        ),
                        8.verticalSpace,
                        _buildCategoryField(),
                        24.verticalSpace,
                        Text(
                          '문의 제목',
                          style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR,
                          ),
                        ),
                        8.verticalSpace,
                        _buildTextField(
                          key: _titleKey,
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          scrollPadding: EdgeInsets.only(
                              bottom: 180
                          ),
                          hintText: '제목을 입력해 주세요',
                        ),
                        24.verticalSpace,
                        Text(
                          '문의 내용',
                          style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR,
                          ),
                        ),
                        8.verticalSpace,
                        _buildTextField(
                          key: _contentKey,
                          controller: _contentController,
                          focusNode: _contentFocusNode,
                          scrollPadding: EdgeInsets.only(
                              bottom: 180
                          ),
                          minLine: 7,
                          hintText: '문의하실 내용을 입력해 주세요',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitInquiry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BLUE400_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  '등록하기',
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isDropdownOpen = !isDropdownOpen;
              FocusScope.of(context).unfocus();
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 48.h,
            decoration: BoxDecoration(
              color: WHITE100_COLOR,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: GRAY200_COLOR),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      _categoryController.text.isEmpty
                          ? '문의 유형을 선택해 주세요'
                          : _categoryController.text,
                      style: AppTextStyles.subtitle.copyWith(
                        color: _categoryController.text.isEmpty
                            ? GRAY400_COLOR
                            : GRAY800_COLOR,
                      ),
                    ),
                  ),
                ),
                if (_categoryController.text.isNotEmpty)
                  IconButton(
                    style: IconButton.styleFrom(
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        _categoryController.clear();
                        isDropdownOpen = false;
                      });
                    },
                    icon: Icon(Icons.close, color: GRAY400_COLOR),
                  ),
              ],
            ),
          ),
        ),
        if (isDropdownOpen)
          Container(
            margin: EdgeInsets.only(top: 8.h),
            decoration: BoxDecoration(
              color: WHITE100_COLOR,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: GRAY200_COLOR),
            ),
            child: Column(
              children: _categories.map((category) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _categoryController.text = category;
                      isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.subtitle.copyWith(
                        color: GRAY800_COLOR,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required FocusNode focusNode,
    required EdgeInsets scrollPadding,
    required String hintText,
    int minLine = 1,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      maxLines: null,
      scrollPadding: scrollPadding,
      minLines: minLine,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.subtitle.copyWith(
          color: GRAY400_COLOR,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: GRAY200_COLOR),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: GRAY200_COLOR),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: BLUE400_COLOR),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
    );
  }
}
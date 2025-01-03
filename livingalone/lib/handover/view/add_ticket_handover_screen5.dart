import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddTicketHandoverScreen5 extends ConsumerStatefulWidget {
  const AddTicketHandoverScreen5({super.key});

  @override
  ConsumerState<AddTicketHandoverScreen5> createState() => _AddRoomHandoverScreen1State();
}

class _AddRoomHandoverScreen1State extends ConsumerState<AddTicketHandoverScreen5> {
  final detailAddressController = TextEditingController();
  final titleFocus = FocusNode();
  final List<File> _images = [];
  final Set<int> _selectedImages = {};
  final _scrollController = ScrollController();
  final _introduceController = TextEditingController();
  final introduceFocus = FocusNode();
  final _introduceKey = GlobalKey();
  final _titleKey = GlobalKey();

  Future<void> _pickImage() async {
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최대 10장까지만 선택 가능합니다.')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 80,
      limit: 10 - _images.length,
    );

    if (images.isNotEmpty) {
      setState(() {
        _images.insertAll(0, images.map((xFile) => File(xFile.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _scrollToField(GlobalKey key) {
    Future.delayed(Duration(milliseconds: 300), () {
      final RenderObject? renderObject = key.currentContext?.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          alignment: 0.1,
          duration: Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  void dispose() {
    detailAddressController.dispose();
    titleFocus.dispose();
    _scrollController.dispose();
    _introduceController.dispose();
    introduceFocus.dispose();
    super.dispose();
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80.w,
        height: 80.h,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: GRAY100_COLOR,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: GRAY200_COLOR),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: GRAY400_COLOR,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(File image, int index) {
    final isSelected = _selectedImages.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedImages.remove(index);
          } else {
            _selectedImages.add(index);
          }
        });
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    image,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    cacheWidth: 160,
                    cacheHeight: 160,
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: BLUE400_COLOR,
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0.h,
            right: 10.w,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: BLUE400_COLOR,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(1),
                  ),
                ),
                child: Icon(
                  Icons.close,
                  color: BLUE100_COLOR,
                  size: 16.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자취방 양도하기',
      showCloseButton: true,
      currentStep: 4,
      totalSteps: 4,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 90,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text('양도할 이용권의 시설을', style: AppTextStyles.heading1.copyWith(color: GRAY800_COLOR),),
                    4.verticalSpace,
                    Text('소개하는 사진과 글을 올려주세요.', style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),),
                    20.verticalSpace,
                    Row(
                      children: [
                        Text('사진', style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),),
                        8.horizontalSpace,
                        Text('최대 10장 가능',style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),)
                      ],
                    ),
                    10.verticalSpace,
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length + (_images.length < 10 ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildAddImageButton();
                          }
                          return _buildImageItem(_images[index - 1], index - 1);
                        },
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      '제목',
                      style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                    ),
                    10.verticalSpace,
                    Container(
                      width: 345.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: GRAY100_COLOR,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: GRAY200_COLOR),
                      ),
                      child: TextFormField(
                        key: _titleKey,
                        controller: detailAddressController,
                        focusNode: titleFocus,
                        onTap: () => _scrollToField(_titleKey),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: detailAddressController.clear,
                            icon: SvgPicture.asset('assets/image/signupDelete.svg',fit: BoxFit.cover,),
                          ),
                          hintText: '예) 모양헬스 강남점, 모양독서실 압구정점',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                            color: GRAY400_COLOR,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      '소개 글',
                      style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                    ),
                    10.verticalSpace,
                    Container(
                      width: 345.w,
                      constraints: BoxConstraints(
                        minHeight: 180.h,
                      ),
                      decoration: BoxDecoration(
                        color: GRAY100_COLOR,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: GRAY200_COLOR),
                      ),
                      child: TextFormField(
                        key: _introduceKey,
                        controller: _introduceController,
                        focusNode: introduceFocus,
                        onTap: (){
                          _scrollToField(_introduceKey);
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '이용권의 종류와 특징을 자세히 소개해 주세요. 양도 수수료 무담 주체 등 추가 정보를 제공하면 더 많은 관심을 받을 수 있어요.',
                          hintStyle: AppTextStyles.subtitle.copyWith(
                            color: GRAY400_COLOR,
                          ),
                          contentPadding: EdgeInsets.all(16.w),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    100.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
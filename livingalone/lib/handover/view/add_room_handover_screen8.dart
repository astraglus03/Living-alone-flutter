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
import 'package:reorderables/reorderables.dart';

class AddRoomHandoverScreen8 extends ConsumerStatefulWidget {
  const AddRoomHandoverScreen8({super.key});

  @override
  ConsumerState<AddRoomHandoverScreen8> createState() => _AddRoomHandoverScreen1State();
}

class _AddRoomHandoverScreen1State extends ConsumerState<AddRoomHandoverScreen8> {
  final titleController = TextEditingController();
  final titleFocus = FocusNode();
  final List<File> _images = [];
  final Set<int> _selectedImages = {};
  final _scrollController = ScrollController();
  final _introduceController = TextEditingController();
  final _introduceFocus = FocusNode();

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

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final File item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocus.dispose();
    _scrollController.dispose();
    _introduceController.dispose();
    _introduceFocus.dispose();
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
        child: Center(
          child: SvgPicture.asset('assets/icons/photo.svg'),
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: 80.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAddImageButton(),
          if (_images.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width - 128.w,
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                onReorder: _onReorder,
                children: _images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final image = entry.value;
                  return _buildImageItem(image, index);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Container(
      key: ValueKey(image.path),
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
          if (index == 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: BLUE400_COLOR,
                    width: 2,
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            top: 0.h,
            right: 0.w,
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
      currentStep: 8,
      totalSteps: 8,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    // bottom: MediaQuery.of(context).viewInsets.bottom + 45,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text('양도할 방의 사진과\n소개 글을 올려주세요', style: AppTextStyles.heading1.copyWith(color: GRAY800_COLOR),),
                      4.verticalSpace,
                      Text('사진과 소개 글은 자세히 올릴수록 효과적 이에요.', style: AppTextStyles.subtitle.copyWith(color: GRAY600_COLOR),),
                      20.verticalSpace,
                      Row(
                        children: [
                          Text('사진', style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),),
                          8.horizontalSpace,
                          Text('최대 10장 가능',style: AppTextStyles.caption2.copyWith(color: GRAY400_COLOR),)
                        ],
                      ),
                      10.verticalSpace,
                      _buildImageList(),
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
                          scrollPadding: EdgeInsets.only(
                            bottom: 90,
                          ),
                          controller: titleController,
                          focusNode: titleFocus,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: titleController.clear,
                              icon: SvgPicture.asset('assets/image/signupDelete.svg',fit: BoxFit.cover,),
                            ),
                            hintText: '모양아파트 101동, 모양빌라',
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
                          controller: _introduceController,
                          focusNode: _introduceFocus,
                          scrollPadding: EdgeInsets.only(
                            bottom: 180,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: '방의 특징과 장점을 소개해 주세요. 자세한 정보를\n제공하면 더 많은 관심을 받을 수 있어요.',
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
      ),
    );
  }
}
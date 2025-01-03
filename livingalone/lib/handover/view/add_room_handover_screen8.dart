import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/home/component/custom_double_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:livingalone/user/component/component_button2.dart';

class AddRoomHandoverScreen8 extends ConsumerStatefulWidget {
  const AddRoomHandoverScreen8({super.key});

  @override
  ConsumerState<AddRoomHandoverScreen8> createState() =>
      _AddRoomHandoverScreen1State();
}

class _AddRoomHandoverScreen1State
    extends ConsumerState<AddRoomHandoverScreen8> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _introduceKey = GlobalKey();
  final addressController = TextEditingController();
  final detailAddressController = TextEditingController();
  final addressFocus = FocusNode();
  final detailAddressFocus = FocusNode();
  final List<File> _images = [];
  final Set<int> _selectedImages = {};

  Future<void> _pickImage() async {
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

  void _scrollToField(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final RenderBox renderBox =
          key.currentContext?.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final fieldHeight = renderBox.size.height + 20; // TextFormField의 높이

      _scrollController.animateTo(
        _scrollController.offset +
            position.dy +
            fieldHeight -
            (MediaQuery.of(context).size.height - keyboardHeight) +
            10.h,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    addressController.dispose();
    detailAddressController.dispose();
    addressFocus.dispose();
    detailAddressFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80.w,
        height: 80.h,
        margin: EdgeInsets.only(right: 10.w),
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
      currentStep: 8,
      totalSteps: 8,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 150.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text(
                        '양도할 방의 사진과\n소개 글을 올려주세요',
                        style: AppTextStyles.heading1
                            .copyWith(color: GRAY800_COLOR),
                      ),
                      4.verticalSpace,
                      Text(
                        '사진과 소개 글은 자세히 올릴수록 효과적 이에요.',
                        style: AppTextStyles.subtitle
                            .copyWith(color: GRAY600_COLOR),
                      ),
                      20.verticalSpace,
                      Row(
                        children: [
                          Text(
                            '사진',
                            style: AppTextStyles.body1
                                .copyWith(color: GRAY800_COLOR),
                          ),
                          8.horizontalSpace,
                          Text(
                            '최대 10장 가능',
                            style: AppTextStyles.caption2
                                .copyWith(color: GRAY400_COLOR),
                          )
                        ],
                      ),
                      10.verticalSpace,
                      SizedBox(
                        height: 80.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              _images.length + (_images.length < 10 ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildAddImageButton();
                            }
                            return _buildImageItem(
                                _images[index - 1], index - 1);
                          },
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        '제목',
                        style:
                            AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      ComponentButton2(
                        controller: detailAddressController,
                        hintText: '모양아파트 101동, 모양빌라',
                        type: TextInputType.text,
                        onPressed: detailAddressController.clear,
                        backgroundColor: GRAY100_COLOR,
                      ),
                      24.verticalSpace,
                      Text(
                        '소개 글',
                        style:
                            AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      Container(
                        key: _introduceKey,
                        width: 345.w,
                        constraints: BoxConstraints(
                          minHeight: 180,
                        ),
                        decoration: BoxDecoration(
                          color: GRAY100_COLOR,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextFormField(
                          maxLines: null,
                          onTap: () => _scrollToField(_introduceKey),
                          onChanged: (_) => _scrollToField(_introduceKey),
                          decoration: InputDecoration(
                            hintText:
                                '방의 특징과 장점을 소개해 주세요. 자세한 정보를\n제공하면 더 많은 관심을 받을 수 있어요.',
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
                      50.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
          CustomDoubleButton(
            onTap: () {
              if (detailAddressController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('제목을 입력해주세요.')),
                );
                return;
              }
              // TODO: 이미지와 제목 데이터 처리
            },
          ),
        ],
      ),
    );
  }
}

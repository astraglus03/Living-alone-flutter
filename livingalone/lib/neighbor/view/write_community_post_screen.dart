import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/component/custom_select_grid.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/community_type.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/neighbor/view_models/write_community_provider.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:livingalone/user/component/component_button2.dart';

class WriteCommunityPostScreen extends ConsumerStatefulWidget {
  final String communityId;
  const WriteCommunityPostScreen({
    required this.communityId,
    super.key
  });

  @override
  ConsumerState<WriteCommunityPostScreen> createState() =>
      _WriteCommunityPostScreenState();
}

class _WriteCommunityPostScreenState extends ConsumerState<WriteCommunityPostScreen> {
  final List<File> _images = [];
  String? selectedItem;
  final _scrollController = ScrollController();
  final titleController = TextEditingController();
  final _introduceController = TextEditingController();
  final introduceFocus = FocusNode();
  final _picker = ImagePicker();
  bool showTitleError = false;
  bool showChooseError = false;
  bool showIntroError = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('최대 5장까지만 선택 가능합니다.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final notifier = ref.read(writeCommunityProvider.notifier);
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 70,
        );

        if (pickedFile != null) {
          setState(() {
            _images.add(File(pickedFile.path));
            notifier.addImages([File(pickedFile.path)]);
          });
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 70,
          limit: 5 - _images.length,
        );

        if (images.isNotEmpty) {
          setState(() {
            final files = images.map((xFile) => File(xFile.path)).toList();
            _images.addAll(files);
            notifier.addImages(files);
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미지를 선택하는 중 오류가 발생했습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _handleTypeSelection(String type) {
    setState(() {
      if (selectedItem == type) {
        selectedItem = null;
      } else {
        selectedItem = type;
        showChooseError = false;
      }
      showChooseError = false;
    });
  }

  void _validateForm() {
    setState(() {
      showChooseError = selectedItem == null;
      showTitleError = titleController.text.trim().isEmpty;
      showIntroError = _introduceController.text.trim().isEmpty;
    });

    if (!showChooseError && !showTitleError && !showIntroError) {
      final notifier = ref.read(writeCommunityProvider.notifier);
      notifier.updateTopic(selectedItem ?? '');
      notifier.updateTitle(titleController.text.trim());
      notifier.updateContent(_introduceController.text.trim());

      notifier.submitPost('1').then((success) {
        if (success) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('게시글 작성에 실패했습니다.')),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    _introduceController.dispose();
    introduceFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeCommunityProvider);
    return DefaultLayout(
      showCloseButton: true,
      title: '커뮤니티 글 쓰기',
      actions: TextButton(
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        onPressed: _validateForm,
        child: Text(
          '완료',
          style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      CustomSingleSelectGrid(
                        label: '주제',
                        items:
                            CommunityType.values.map((e) => e.label).toList(),
                        selectedItem: selectedItem,
                        onItemSelected: _handleTypeSelection,
                      ),
                      if (showChooseError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '주제를 선택해주세요'),
                        ),
                      28.verticalSpace,
                      Text(
                        '제목',
                        style:
                            AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      ComponentButton(
                        controller: titleController,
                        hintText: '제목을 입력해주세요',
                        type: TextInputType.text,
                        onPressed: titleController.clear,
                      ),
                      if (showTitleError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '제목을 입력해주세요'),
                        ),
                      28.verticalSpace,
                      Text(
                        '내용',
                        style:
                            AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                      ),
                      10.verticalSpace,
                      Container(
                        width: 345.w,
                        constraints: BoxConstraints(
                          minHeight: 180.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: GRAY200_COLOR),
                        ),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.only(
                            bottom: 180,
                          ),
                          controller: _introduceController,
                          focusNode: introduceFocus,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: '자유롭게 이야기해 보세요',
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
                      if (showIntroError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '소개글을 입력해주세요'),
                        ),
                      80.verticalSpace,
                      _buildImageList(),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: WHITE100_COLOR,
              border: Border(
                top: BorderSide(
                  color: GRAY200_COLOR,
                  width: 1.w,
                ),
              ),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom : 34.h,
            ),
            child: Row(
              children: [
                14.horizontalSpace,
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt_rounded, color: GRAY400_COLOR),
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo, color: GRAY400_COLOR),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return SizedBox(
      height: _images.isEmpty ? 0 : 80.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_images.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
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
}

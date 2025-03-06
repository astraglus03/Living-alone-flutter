import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:livingalone/common/component/confirm_dialog.dart';
import 'package:livingalone/common/component/custom_select_grid.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/enum/community_type.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/neighbor/view_models/community_edit_provider.dart';
import 'package:livingalone/user/component/component_button.dart';
import 'package:livingalone/user/component/component_button2.dart';
import 'package:livingalone/neighbor/models/post_detail_model.dart';

class EditCommunityPostScreen extends ConsumerStatefulWidget {
  final String communityId;
  final String postId;
  final PostDetailModel initialData;

  const EditCommunityPostScreen({
    required this.communityId,
    required this.postId,
    required this.initialData,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditCommunityPostScreen> createState() => _EditCommunityPostScreenState();
}

class _EditCommunityPostScreenState extends ConsumerState<EditCommunityPostScreen> {
  final _scrollController = ScrollController();
  final titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocus = FocusNode();
  final _picker = ImagePicker();
  final List<File> _localImages = [];
  final List<String> _uploadedImages = [];

  String? selectedTopic;
  bool showTopicError = false;
  bool showTitleError = false;
  bool showContentError = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _initializeData();
    });
  }

  void _initializeData() {
    selectedTopic = widget.initialData.topic;
    titleController.text = widget.initialData.title;
    _contentController.text = widget.initialData.content;
    _uploadedImages.addAll(widget.initialData.imageUrls);
    
    // 초기 데이터로 provider 상태 업데이트
    final notifier = ref.read(communityEditProvider(widget.postId).notifier);
    notifier.updateTopic(widget.initialData.topic);
    notifier.updateTitle(widget.initialData.title);
    notifier.updateContent(widget.initialData.content);
    notifier.setImages(widget.initialData.imageUrls);
  }

  Future<void> _handleImagePick(ImageSource source) async {
    if (_localImages.length + _uploadedImages.length >= 5) {
      _showErrorSnackBar('최대 5장까지만 선택 가능합니다.');
      return;
    }

    try {
      final notifier = ref.read(communityEditProvider(widget.postId).notifier);
      if (source == ImageSource.camera) {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 70,
        );
        if (pickedFile != null) {
          setState(() {
            _localImages.add(File(pickedFile.path));
          });
          final file = await MultipartFile.fromFile(pickedFile.path, filename: pickedFile.name);
          notifier.uploadImages([file]);
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 70,
          limit: 5 - (_localImages.length + _uploadedImages.length),
        );
        if (images.isNotEmpty) {
          setState(() {
            _localImages.addAll(images.map((xFile) => File(xFile.path)));
          });
          final multipartFiles = await Future.wait(
            images.map((file) => MultipartFile.fromFile(file.path, filename: file.name))
          );
          notifier.uploadImages(multipartFiles);
        }
      }
    } catch (e) {
      _showErrorSnackBar('이미지를 선택하는 중 오류가 발생했습니다.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleTopicSelection(String topic) {
    setState(() {
      selectedTopic = selectedTopic == topic ? null : topic;
      showTopicError = false;
    });
  }

  Future<void> _handleSubmit() async {
    if (_validateForm()) {
      final notifier = ref.read(communityEditProvider(widget.postId).notifier);
      final currentState = ref.read(communityEditProvider(widget.postId));

      if (currentState.topic != selectedTopic) {
        notifier.updateTopic(selectedTopic ?? '');
      }
      if (currentState.title != titleController.text.trim()) {
        notifier.updateTitle(titleController.text.trim());
      }
      if (currentState.content != _contentController.text.trim()) {
        notifier.updateContent(_contentController.text.trim());
      }

      final success = await notifier.updatePost();
      if (success) {
        Navigator.pop(context);
      } else {
        _showErrorSnackBar('게시글 수정에 실패했습니다.');
      }
    }
  }

  bool _validateForm() {
    setState(() {
      showTopicError = selectedTopic == null;
      showTitleError = titleController.text.trim().isEmpty;
      showContentError = _contentController.text.trim().isEmpty;
    });
    return !showTopicError && !showTitleError && !showContentError;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityEditProvider(widget.postId));

    return DefaultLayout(
      showCloseButton: true,
      title: '글 수정하기',
      actions: _buildSubmitButton(),
      child: Column(
        children: [
          Expanded(
            child: _buildFormContent(state),
          ),
          _buildImagePickerButtons(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      style: TextButton.styleFrom(overlayColor: Colors.transparent),
      onPressed: _handleSubmit,
      child: Text(
        '완료',
        style: AppTextStyles.subtitle.copyWith(color: GRAY800_COLOR),
      ),
    );
  }

  Widget _buildFormContent(CommunityEditState state) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              _buildTopicSelector(),
              28.verticalSpace,
              _buildTitleField(),
              28.verticalSpace,
              _buildContentField(),
              80.verticalSpace,
              _buildImageList(state.images),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSingleSelectGrid(
          label: '주제',
          items: CommunityType.values.map((e) => e.label).toList(),
          selectedItem: selectedTopic,
          onItemSelected: _handleTopicSelection,
        ),
        if (showTopicError)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: ShowErrorText(errorText: '주제를 선택해주세요'),
          ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '제목',
          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
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
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내용',
          style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
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
            controller: _contentController,
            focusNode: _contentFocus,
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
        if (showContentError)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: ShowErrorText(errorText: '내용을 입력해주세요'),
          ),
      ],
    );
  }

  Widget _buildImageList(List<String> serverImages) {
    final allImages = [..._uploadedImages, ..._localImages.map((file) => file.path)];
    if (allImages.isEmpty) return SizedBox.shrink();

    return SizedBox(
      height: 80.h,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allImages.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final isLocal = oldIndex >= _uploadedImages.length;

            if (isLocal) {
              // 로컬 이미지 재정렬
              final item = _localImages.removeAt(oldIndex - _uploadedImages.length);
              _localImages.insert(
                  newIndex - _uploadedImages.length,
                  item
              );
            } else if (newIndex < _uploadedImages.length) {
              // 업로드된 이미지 재정렬
              final item = _uploadedImages.removeAt(oldIndex);
              _uploadedImages.insert(newIndex, item);

              // Provider 상태 업데이트
              ref.read(communityEditProvider(widget.postId).notifier)
                  .reorderImages(oldIndex, newIndex);
            }
          });
        },
        itemBuilder: (context, index) {
          final isLocal = index >= _uploadedImages.length;
          final imagePath = allImages[index];

          return Container(
            key: ValueKey(imagePath), // ReorderableListView를 위한 고유 키
            margin: EdgeInsets.only(right: 10.w),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: isLocal
                      ? Image.file(
                    File(imagePath),
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    cacheWidth: 160,
                    cacheHeight: 160,
                  )
                      : Image.network(
                    imagePath,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    cacheWidth: 160,
                    cacheHeight: 160,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: frame != null
                            ? child
                            : Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: GRAY100_COLOR,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: GRAY100_COLOR,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: GRAY400_COLOR,
                        ),
                      );
                    },
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isLocal) {
                          _localImages.removeAt(index - _uploadedImages.length);
                        } else {
                          final imageUrl = _uploadedImages[index];
                          _uploadedImages.removeAt(index);
                          ref.read(communityEditProvider(widget.postId).notifier)
                              .removeImage(imageUrl);
                        }
                      });
                    },
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
        },
      ),
    );
  }

  Widget _buildImagePickerButtons() {
    return Container(
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
            ? MediaQuery.of(context).viewInsets.bottom
            : 34.h,
      ),
      child: Row(
        children: [
          14.horizontalSpace,
          _buildImagePickerButton(
            icon: Icons.camera_alt_rounded,
            onPressed: () => _handleImagePick(ImageSource.camera),
          ),
          _buildImagePickerButton(
            icon: Icons.photo,
            onPressed: () => _handleImagePick(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        style: IconButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: GRAY400_COLOR),
      ),
    );
  }
}

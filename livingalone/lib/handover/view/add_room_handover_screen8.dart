import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/handover/view_models/handover_check_provider.dart';
import 'package:livingalone/handover/view_models/room_handover_provider.dart';
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
  final _scrollController = ScrollController();
  final _introduceController = TextEditingController();
  final _introduceFocus = FocusNode();
  bool showImageError = false;
  bool showTitleError = false;
  bool showIntroduceError = false;

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
      final files = images.map((xFile) => File(xFile.path)).toList();
      ref.read(roomHandoverProvider.notifier).addImages(files);
      setState(() {
        _images.insertAll(0, files);
        if (showImageError) showImageError = false;
      });
    }
  }

  void _removeImage(int index) {
    ref.read(roomHandoverProvider.notifier).removeImage(index);
    setState(() {
      _images.removeAt(index);
      if (_images.isEmpty) showImageError = true;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final File item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
      
      // Provider 상태 업데이트
      ref.read(roomHandoverProvider.notifier).update(
        images: _images,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      if (titleController.text.isNotEmpty && showTitleError) {
        setState(() {
          showTitleError = false;
        });
      }
    });

    _introduceController.addListener(() {
      if (_introduceController.text.isNotEmpty && showIntroduceError) {
        setState(() {
          showIntroduceError = false;
        });
      }
    });
  }

  void _validateForm() {
    setState(() {
      showImageError = _images.isEmpty;
      showTitleError = titleController.text.trim().isEmpty;
      showIntroduceError = _introduceController.text.trim().isEmpty;
    });

    if (!showImageError && !showTitleError && !showIntroduceError) {
      // Provider에 최종 데이터 저장
      ref.read(roomHandoverProvider.notifier).update(
        images: _images,
        description: _introduceController.text,
      );

      // final roomState = ref.watch(roomHandoverProvider);
      // final checkState = ref.watch(roomHandoverCheckProvider);
      //
      // // 주소 정보
      // print('\n=== 위치 정보 ===');
      // print({
      //   '주소': roomState.address,
      //   '상세주소': roomState.detailAddress,
      // });
      //
      // // 건물 정보
      // print('\n=== 건물 정보 ===');
      // print({
      //   '건물 유형': roomState.buildingType,
      //   '매물 종류': roomState.propertyType,
      //   '층수': roomState.floor,
      //   '면적': roomState.area,
      // });
      //
      // // 계약 정보
      // print('\n=== 계약 정보 ===');
      // print({
      //   '임대 방식': roomState.rentType,
      //   '보증금': roomState.deposit,
      //   '월세': roomState.monthlyRent,
      //   '관리비': roomState.maintenance,
      // });
      //
      // // 입주 정보
      // print('\n=== 입주 정보 ===');
      // print({
      //   '입주 가능일': roomState.availableDate,
      //   '즉시 입주 가능': roomState.immediateIn,
      // });
      //
      // // 추가 정보
      // print('\n=== 추가 정보 ===');
      // print({
      //   '시설': roomState.facilities.map((e) => e.label).toList(),
      //   '조건': roomState.conditions.map((e) => e.label).toList(),
      // });
      //
      // // 설명
      // print('\n=== 상세 설명 ===');
      // print({
      //   '설명': roomState.description,
      // });
      //
      // // 이미지
      // print('\n=== 이미지 정보 ===');
      // print({
      //   '이미지 개수': roomState.images.length,
      //   '이미지 경로': roomState.images.map((e) => e.path).toList(),
      // });
      //
      // // 개인정보 동의
      // print('\n=== 개인정보 동의 ===');
      // print({
      //   '게시물 타입': checkState.postType?.label,
      //   '동의 여부': checkState.isChecked,
      //   '동의 시간': checkState.checkedAt?.toIso8601String(),
      // });


      // // API 호출
      // ref.read(roomHandoverProvider.notifier).submit().then((_) {
      //   // 성공 시 처리
      //   Navigator.of(context).pop(); // 또는 완료 화면으로 이동
      // }).catchError((error) {
      //   // 에러 처리
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('업로드 실패: ${error.toString()}')),
      //   );
      // });
    }
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.verticalSpace,
                      Text('양도할 방의 사진과\n소개 글을 올려주세요', style: AppTextStyles.heading2.copyWith(color: GRAY800_COLOR),),
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
                      if (showImageError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '사진을 1장 이상 등록해주세요'),
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
                          scrollPadding: EdgeInsets.only(
                            bottom: 150,
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
                      if (showTitleError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '제목을 입력해주세요'),
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
                      if (showIntroduceError)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: ShowErrorText(errorText: '소개글을 입력해주세요'),
                        ),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            CustomDoubleButton(
              onTap: _validateForm,
            ),
          ],
        ),
      ),
    );
  }
}
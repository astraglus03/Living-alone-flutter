import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/component/show_error_text.dart';
import 'package:livingalone/common/const/colors.dart';
import 'package:livingalone/common/const/text_styles.dart';
import 'package:livingalone/common/layout/default_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/view_models/user_me_provider.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:livingalone/mypage/view_models/mypage_provider.dart';

class AddressSettingScreen extends ConsumerStatefulWidget {
  const AddressSettingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddressSettingScreen> createState() => _AddressSettingScreenState();
}

class _AddressSettingScreenState extends ConsumerState<AddressSettingScreen> {
  final TextEditingController addressController = TextEditingController();
  String? addressError;
  bool isAddressSearchOpen = false;
  String address ='';

  @override
  void initState() {
    super.initState();
    // 현재 주소 가져오기
    final currentUser = ref.read(userMeProvider);

    if(currentUser is UserModel){
      address = currentUser.address!;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _openAddressSearch() async {
    isAddressSearchOpen = true;
    KopoModel? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    if (model != null) {
      setState(() {
        address = '${model.address} ${model.buildingName}'.trim();
        addressError = null;
      });
    }
    isAddressSearchOpen = false;
  }

  void _handleSubmit() {
    if (address.isEmpty) {
      setState(() {
        addressError = '주소를 입력해주세요';
      });
      return;
    }


    // 주소가 변경된 경우에만 API 호출
    ref.read(userMeProvider.notifier).updateAddress(address);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userMeProvider);

    if (profile is UserModelLoading) {
      return const DefaultLayout(
        title: '우리집 설정',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profile is UserModelError) {
      return DefaultLayout(
        title: '우리집 설정',
        child: Center(
          child: Text('우리집을 불러올 수 없습니다: ${profile.message}'),
        ),
      );
    }

    final user = profile as UserModel;

    return DefaultLayout(
      title: '우리집 설정',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '주소',
                    style: AppTextStyles.body1.copyWith(color: GRAY800_COLOR),
                  ),
                  10.verticalSpace,
                  Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: GRAY100_COLOR,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: GRAY200_COLOR),
                    ),
                    child: TextFormField(
                      controller: addressController,
                      readOnly: true,
                      onTap: _openAddressSearch,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
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
                        suffixIcon: IconButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: _openAddressSearch,
                          icon: Icon(
                            Icons.search,
                            color: GRAY600_COLOR,
                            size: 24,
                          ),
                        ),
                        hintText: '예) 상명대길 31, 안서동 300',
                        hintStyle: AppTextStyles.subtitle.copyWith(
                          color: GRAY400_COLOR,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      ),
                    ),
                  ),
                  if (addressError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: ShowErrorText(errorText: addressError!),
                    ),
                  if (user.address != null && user.address!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: BLUE100_COLOR,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            width: 1.w,
                            color: BLUE400_COLOR,
                          )
                        ),
                        child: Text(
                          address,
                          style: AppTextStyles.body1.copyWith(
                            color: GRAY800_COLOR,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BLUE400_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  '변경하기',
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
} 
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:livingalone/mypage/models/nickname_check_response.dart';
import 'package:livingalone/user/models/verification_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/user/models/user_model.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserMeRepository(dio, baseUrl: 'https://$ip/user');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  // 내정보 가져오기
  @GET('/me')
  Future<UserModel> getMe();

  // 로그아웃(mypage/view/edit_profile_screend.dart)
  @POST('/logout')
  Future<void> logout();

  // 회원 탈퇴
  @DELETE('/withdrawal')
  Future<void> withdrawal();

  // 프로필 변경하기(mypage/view/edit_profile_screend.dart)
  @PATCH('/profile')
  Future<UserModel> updateProfile({
    @Body() required Map<String, dynamic> body,
  });

  // 비밀번호 변경
  @PATCH('/password')
  Future<void> changePassword({
    @Body() required Map<String, dynamic> body,
  });

  // 비밀번호 재설정 이메일 전송하기(user/view/find_password_screen.dart)
  @POST('/me/verify-email')
  Future<VerificationResponse> sendPasswordResetEmail({
    @Field('email') required String email,
  });

  // 인증코드 재전송(user/view/find_password_auth_screen.dart)
  @POST('/me/resend-code')
  Future<VerificationResponse> resendVerificationCode({
    @Field('email') required String email,
  });

  // 인증코드 확인(user/view/find_password_auth_screen.dart)
  @POST('/me/verify-code')
  Future<VerificationResponse> sendVerifyCode({
    @Field('email') required String email,
    @Field('code') required String code,
  });

  // 마이페이지 비밀번호 변경(mypage/view/change_password_screen.dart)
  @PATCH('/me/password')
  Future<UserModel> patchPassword({
    @Field('email') required String email,
    @Field('verificationCode') required String verificationCode,
    @Field('newPassword') required String newPassword,
  });

  // 비번 찾기 비밀번호 변경(user/view/reset_password_screen.dart)
  @PATCH('/me/password')
  Future<UserModel> resetPassword({
    @Field('email') required String email,
    @Field('verificationCode') required String verificationCode,
    @Field('newPassword') required String newPassword,
  });

  // 닉네임 중복 확인
  @GET('/check-nickname')
  Future<NicknameCheckResponse> checkNickname({
    @Query('nickname') required String nickname,
  });

  // 알림 설정 업데이트
  @PATCH('/notifications')
  Future<UserModel> updateNotificationSettings({
    @Body() required Map<String, dynamic> body,
  });

  // 언어 설정 업데이트
  @PATCH('/language')
  Future<UserModel> updateLanguage({
    @Body() required Map<String, dynamic> body,
  });

  // 주소 설정 업데이트
  @PATCH('/address')
  Future<UserModel> updateAddress({
    @Body() required Map<String, dynamic> body,
  });
}
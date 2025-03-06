import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/user_profile_model.dart';
import 'package:livingalone/mypage/models/nickname_check_response.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';

part 'mypage_repository.g.dart';

final myPageRepositoryProvider = Provider<MyPageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MyPageRepository(dio, baseUrl: 'http://$ip/api/v1/mypage');
});

@RestApi()
abstract class MyPageRepository {
  factory MyPageRepository(Dio dio, {String baseUrl}) = _MyPageRepository;

  // 프로필 조회
  @GET('/profile')
  Future<UserProfileModel> getProfile();

  // 프로필 수정
  @PATCH('/profile')
  Future<UserProfileModel> updateProfile({
    @Body() required Map<String, dynamic> body,
  });

  // 비밀번호 변경
  @PATCH('/password')
  Future<void> changePassword({
    @Body() required Map<String, dynamic> body,
  });

  // 알림 설정 업데이트
  @PATCH('/notifications')
  Future<UserProfileModel> updateNotificationSettings({
    @Body() required Map<String, dynamic> body,
  });

  // 언어 설정 업데이트
  @PATCH('/language')
  Future<UserProfileModel> updateLanguage({
    @Body() required Map<String, dynamic> body,
  });

  // 주소 설정 업데이트
  @PATCH('/address')
  Future<UserProfileModel> updateAddress({
    @Body() required Map<String, dynamic> body,
  });

  // 회원 탈퇴
  @DELETE('/withdrawal')
  Future<void> withdrawal();

  // 로그아웃
  @POST('/logout')
  Future<void> logout();

  // 닉네임 중복 확인
  @GET('/check-nickname')
  Future<NicknameCheckResponse> checkNickname({
    @Query('nickname') required String nickname,
  });
}


// 더미 데이터용 Provider
final dummyMyPageRepositoryProvider = Provider<DummyMypageRepository>((ref) {
  return DummyMypageRepository();
});

class DummyMypageRepository {
  Future<UserProfileModel> getProfile() async {
    // 더미 데이터 반환
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<UserProfileModel> updateProfile({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: body['nickname'] ?? '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: body['profileImage'] ?? 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<void> changePassword({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return;
  }

  Future<UserProfileModel> updateNotificationSettings({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: body['pushNotificationEnabled'] ?? true,
      chatNotificationEnabled: body['chatNotificationEnabled'] ?? true,
      neighborNotificationEnabled: body['neighborNotificationEnabled'] ?? true,
      handoverNotificationEnabled: body['handoverNotificationEnabled'] ?? true,
      communityNotificationEnabled: body['communityNotificationEnabled'] ?? true,
      noticeNotificationEnabled: body['noticeNotificationEnabled'] ?? true,
      address: '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<UserProfileModel> updateLanguage({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: body['language'] ?? '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<UserProfileModel> updateAddress({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: body['address'] ?? '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500));
    return;
  }

  Future<void> withdrawal() async {
    await Future.delayed(Duration(milliseconds: 500));
    return;
  }

  Future<NicknameCheckResponse> checkNickname({
    required String nickname,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    // 더미 데이터에서는 'duplicate'라는 닉네임만 중복으로 처리
    final isAvailable = nickname != 'duplicate';
    return NicknameCheckResponse(
      available: isAvailable,
      message: isAvailable ? '사용 가능한 닉네임입니다' : '이미 사용중인 닉네임입니다',
    );
  }
}
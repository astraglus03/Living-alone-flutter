import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/secure_storage/secure_storage.dart';
import 'package:livingalone/mypage/models/nickname_check_response.dart';
import 'package:livingalone/user/models/signup_request_model.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/models/verification_model.dart';
import 'package:livingalone/user/repository/auth_repository.dart';
import 'package:livingalone/user/repository/user_me_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return UserStateNotifier(
    ref: ref,
    authRepository: authRepository,
    repository: userMeRepository,
    storage: storage,
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final Ref ref;
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserStateNotifier({
    required this.ref,
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(
          UserModelLoading(),
        ) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    try {
      final resp = await repository.getMe();
      state = resp;
    } catch (e) {
      state = null;
    }
  }

  Future<UserModelBase> login({
    required String email,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        email: email,
        password: password,
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);

      final userResp = await repository.getMe();
      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;
    try {
      await repository.logout();
      await Future.wait([
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ]);
    } catch (e) {
      state = UserModelError(message: '로그아웃에 실패했습니다.');
    }
  }

  Future<void> withdrawal() async {
    state = null;
    try {
      await repository.withdrawal();
      await Future.wait([
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ]);
    } catch (e) {
      state = UserModelError(message: '회원탈퇴에 실패했습니다.');
    }
  }


  // 비밀번호 재설정 관련 메서드 추가
  Future<VerificationResponse> sendVerificationEmail(String email) async {
    try {
      final response = await repository.sendPasswordResetEmail(email: email);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VerificationResponse> sendVerifyCode(String email, String code) async {
    try {
      final response = await repository.sendVerifyCode(
        email: email,
        code: code,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModelBase> resetPassword({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    try {
      final userResp = await repository.resetPassword(
        email: email,
        verificationCode: verificationCode,
        newPassword: newPassword,
      );
      return userResp;
    } catch (e) {
      throw Exception('비밀번호 재설정에 실패했습니다.');
    }
  }

  // 프로필 업데이트 메서드 추가
  Future<UserModelBase> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      state = UserModelLoading();
      final userResp = await repository.updateProfile(body: updates);
      state = userResp;
      return userResp;
    } catch (e) {
      throw Exception('프로필 업데이트에 실패했습니다.');
    }
  }

  // 언어 변경 관련 api
  Future<UserModelBase> updateLanguage(String language) async {
    try {
      state = UserModelLoading();
      final userResp =
          await repository.updateLanguage(body: {'language': language});
      state = userResp;
      return userResp;
    } catch (e) {
      throw Exception('언어 설정 업데이트에 실패했습니다.');
    }
  }

  Future<NicknameCheckResponse> checkNicknameAvailability(
      {required String nickname}) async {
    try {
      // 상태를 로딩으로 변경하지 않음 (UI가 깜빡이는 것 방지)
      final response = await repository.checkNickname(nickname: nickname);
      return response; // 전체 응답 객체 반환
    } catch (e) {
      throw Exception('닉네임 중복 확인에 실패했습니다.');
    }
  }

  // 주소 업데이트 메서드
  Future<UserModelBase> updateAddress(String address) async {
    try {
      state = UserModelLoading();
      final userResp = await repository.updateAddress(body: {'address': address});
      state = userResp;
      return userResp;
    } catch (e) {
      throw Exception('주소 업데이트에 실패했습니다.');
    }
  }

  // 비밀번호 변경 메서드
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      state = UserModelLoading();
      await repository.changePassword(
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      // 비밀번호 변경 후 사용자 정보 다시 가져오기
      final userResp = await repository.getMe();
      state = userResp;

      return;
    } catch (e) {
      state = UserModelError(message: '비밀번호 변경에 실패했습니다.');
      throw Exception('비밀번호 변경에 실패했습니다: ${e.toString()}');
    }
  }

  // 알림 설정
  Future<UserModelBase> updateNotificationSettings({required bool alarm}) async {
    try {
      state = UserModelLoading();

      // API 호출로 알림 설정 업데이트
      await repository.updateNotificationSettings(
        body: {
          'serviceAlarm': alarm
        },
      );
      
      // 최신 사용자 정보 가져오기
      final userResp = await repository.getMe();
      state = userResp;
      
      return userResp; // 명시적으로 UserModelBase 반환
    } catch (e) {
      final errorState = UserModelError(message: e.toString());
      state = errorState;
      return errorState; // 오류 상태도 UserModelBase 반환
    }
  }
}

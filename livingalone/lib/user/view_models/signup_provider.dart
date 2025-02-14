import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/models/signup_request_model.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/models/verification_model.dart';
import 'package:livingalone/user/repository/auth_repository.dart';

final signupProvider = StateNotifierProvider<SignupStateNotifier, UserModelBase?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupStateNotifier(repository: repository);
});

class SignupStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository repository;

  SignupStateNotifier({
    required this.repository,
  }) : super(null);

  // 이메일 인증 요청
  Future<VerificationResponse> sendEmailVerification({
    required String email,
    required String university,
  }) async {
    try {
      final response = await repository.sendEmailVerification(
        request: EmailVerificationRequest(
          email: email,
          university: university,
        ),
      );
      return response;
    } catch (e) {
      state = UserModelError(message: '이메일 인증 요청에 실패했습니다.');
      rethrow;
    }
  }

  // 이메일 인증 코드 확인
  Future<VerificationResponse> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await repository.verifyEmailCode(
        email: email,
        code: code,
      );
      return response;
    } catch (e) {
      state = UserModelError(message: '이메일 인증에 실패했습니다.');
      rethrow;
    }
  }

  // 휴대폰 인증 요청
  Future<VerificationResponse> sendPhoneVerification({
    required String phoneNumber,
    required String carrier,
  }) async {
    try {
      final response = await repository.sendPhoneVerification(
        phoneNumber: phoneNumber,
        carrier: carrier,
      );
      return response;
    } catch (e) {
      state = UserModelError(message: '휴대폰 인증 요청에 실패했습니다.');
      rethrow;
    }
  }

  // 휴대폰 인증 코드 확인
  Future<VerificationResponse> verifyPhoneCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await repository.verifyPhoneCode(
        phoneNumber: phoneNumber,
        code: code,
      );
      return response;
    } catch (e) {
      state = UserModelError(message: '휴대폰 인증에 실패했습니다.');
      rethrow;
    }
  }

  // 닉네임 중복 확인
  Future<bool> checkNicknameAvailability({
    required String nickname,
  }) async {
    try {
      return await repository.checkNicknameAvailability(
        nickname: nickname,
      );
    } catch (e) {
      state = UserModelError(message: '닉네임 중복 확인에 실패했습니다.');
      rethrow;
    }
  }

  // 회원가입 완료
  Future<UserModel> register({
    required String email,
    required String password,
    required String nickname,
    required String phoneNumber,
    required String university,
    String? profileImage,
  }) async {
    state = UserModelLoading();

    try {
      final user = await repository.register(
        request: SignUpRequest(
          id: null,
          email: email,
          password: password,
          nickname: nickname,
          phoneNumber: phoneNumber,
          university: university,
          profileImage: profileImage,
        ),
      );
      state = user;
      return user;
    } catch (e) {
      state = UserModelError(message: '회원가입에 실패했습니다.');
      rethrow;
    }
  }
} 
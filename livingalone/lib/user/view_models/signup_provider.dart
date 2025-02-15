import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/user/models/signup_request_model.dart';
import 'package:livingalone/user/models/user_model.dart';
import 'package:livingalone/user/models/verification_model.dart';
import 'package:livingalone/user/repository/auth_repository.dart';

final signupProvider = StateNotifierProvider<SignupStateNotifier, SignUpRequest?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupStateNotifier(repository: repository);
});

class SignupStateNotifier extends StateNotifier<SignUpRequest?> {
  final AuthRepository repository;

  SignupStateNotifier({
    required this.repository,
  }) : super(SignUpRequest(
          email: '',
          password: '',
          nickname: '',
          phoneNumber: '',
          university: '',
          termsAgreed: false,
          privacyAgreed: false,
    alarmAgreed: false,
        ));

  // 약관 동의 상태 getter
  bool get isTermsAgreed => state?.termsAgreed ?? false;
  bool get isPrivacyAgreed => state?.privacyAgreed ?? false;
  bool get isAllTermsAgreed => (state?.termsAgreed ?? false) && (state?.privacyAgreed ?? false);

  bool get isAlarmAgreed => state?.alarmAgreed ?? false;

  // 약관 동의 상태 설정
  void setTermsAgreement(bool agreed) {
    state = state!.copyWith(
      termsAgreed: agreed,
    );
  }

  // 서비스 약관 동의
  void setPrivacyAgreement(bool agreed) {
    state = state!.copyWith(
      privacyAgreed: agreed,
    );
  }

  // 알림 수신 동의
  void setAlarmAgreement(bool agreed) {
    state = state!.copyWith(
      alarmAgreed: agreed,
    );
  }

  // 대학생 인증 이메일 학교 추가
  void setEmailUniversity(String email, String university) {
    state = state!.copyWith(
      email: email,
      university: university,
    );
  }

  // 휴대전화 인증 추가
  void setPhoneNumberCarrier(String phoneNumber) {
    state = state!.copyWith(
      phoneNumber: phoneNumber,
      // carrier: carrier,
    );
  }

  // 비밀번호 설정
  void setPassword(String password) {
    state = state!.copyWith(
      password: password,
    );
  }

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
      throw Exception('이메일 인증 요청에 실패했습니다.');
    }
  }

  // 이메일 인증 코드 확인
  Future<VerificationResponse> verifyEmailCode({
    required String email,
    required String university,
    required String code,
  }) async {
    try {
      final response = await repository.verifyEmailCode(
        email: email,
        university: university,
        code: code,
      );
      state = state!.copyWith(
        email: email,
        university: university,
      );
      return response;
    } catch (e) {
      throw Exception('이메일 인증에 실패했습니다.');
    }
  }

  // 휴대폰 인증 요청
  Future<PhoneVerificationRequest> sendPhoneVerification({
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
      throw Exception('휴대폰 인증 요청에 실패했습니다.');
    }
  }

  // 휴대폰 인증 코드 확인
  Future<VerificationResponse> verifyPhoneCode({
    required String phoneNumber,
    required String carrier,
    required String code,
  }) async {
    try {
      final response = await repository.verifyPhoneCode(
        phoneNumber: phoneNumber,
        carrier : carrier,
        code: code,
      );
      return response;
    } catch (e) {
      throw Exception('휴대폰 인증에 실패했습니다.');
    }
  }

  // 닉네임 중복 확인
  Future<bool> checkNicknameAvailability({
    required String nickname,
  }) async {
    try {
      final resp = await repository.checkNicknameAvailability(nickname: nickname,);
      if(resp){
        return resp;
      }
      return resp;

    } catch (e) {
      throw Exception('닉네임 중복 확인에 실패했습니다.');
    }
  }

  // 회원가입 완료
  Future<void> register({
    required String nickName,
    File? image,
  }) async {
    try {
      // 닉네임 설정
      state = state!.copyWith(
        nickname: nickName,
      );

      // 필수 정보 검증
      if (state == null ||
          state!.email.isEmpty ||
          state!.password.isEmpty ||
          state!.nickname.isEmpty ||
          state!.phoneNumber.isEmpty ||
          state!.university.isEmpty ||
          !state!.termsAgreed ||
          !state!.privacyAgreed
      ) {
        throw Exception('필수 회원정보가 모두 입력되지 않았습니다.');
      }

      final requestJson = jsonEncode(state!.toJson());

      // 회원가입 요청 (이미지와 함께 multipart로 전송)
      await repository.register(
        request: requestJson,
        profileImage: image,
      );
    } on Exception catch (e) {
      // 구체적인 예외 처리
      if (e.toString().contains('중복된 이메일')) {
        throw Exception('이미 사용 중인 이메일입니다.');
      } else if (e.toString().contains('중복된 닉네임')) {
        throw Exception('이미 사용 중인 닉네임입니다.');
      } else {
        throw Exception('회원가입에 실패했습니다. 다시 시도해 주세요.');
      }
    } catch (e) {
      // 예상치 못한 에러
      throw Exception('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    }
  }
} 